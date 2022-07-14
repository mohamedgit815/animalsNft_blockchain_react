import Link from "next/link";
import { useEffect, useState } from 'react';
import detectEthereumProvider from '@metamask/detect-provider';
import Web3 from "web3";
import {create} from 'ipfs-http-client';
import AnimalsNft from "../pages/abi/AnimalNft.json";

const _clinet = create("https://ipfs.infura.io:5001/api/v0");

export default function Home () {

  const _providerChange = (provider)=>{
    provider.on("accountsChanged",()=>{window.location.reload()});
    provider.on("chainChanged",()=>{window.location.reload()});
  }

  const [ web3 , setWeb3 ] = useState({
    web3: null , 
    account: null , 
    provider: null ,
    networkId: null
  });
  useEffect(() => {
    const _loadContract = async ()=>{
      const _provider = await detectEthereumProvider();

      if(_provider) {
        _providerChange(_provider);

        const _web3 = await new Web3(_provider);
        const _account = await _web3.eth.getAccounts();
        const _netWorkId = await _web3.eth.net.getId();     

          setWeb3({
            web3: _web3 ,
            account: _account[0] ,
            provider: _provider , 
            networkId: _netWorkId
          });

      } else {
        window.alert("Enter your Wallet MetaMask");
      }


    }
      _loadContract();
  },[]);

  const [animalsContract , setAnimalsContract] = useState({
    contract: null , 
    checkContract: undefined , 
    balanceUser: 0 ,
    count: 0 , 
    //idUsers: 0 ,
    //ownerContract: null ,
    //balanceContract: 0 , 
    totalSupply: 0 
  });
  useEffect(() => {
    const _loadContract = async () => {

      const _contractObject = await AnimalsNft.networks[web3.networkId];

      if( _contractObject ) {
        const _contractAddress = await AnimalsNft.networks[web3.networkId].address;
        
        const _deployedContract = await new web3.web3.eth.Contract(
          AnimalsNft.abi,_contractObject && _contractAddress);

        const _balance = await web3.web3.eth.getBalance(web3.account);
        const _total = await _deployedContract.methods.totalSupply().call();
        const _idCount = await _deployedContract.methods.getAnimalsNft().call();

        setAnimalsContract({
          contract: _deployedContract ,
          checkContract: true ,
          balanceUser: _balance , 
          totalSupply: _total ,
          count: _idCount
        });

      } 
    }

     web3.account && _loadContract();

  },[web3.account]);


  const [imageUrl,setImageUrl] = useState();
  const _onChange = async (e) => {

    const _file = e.target.files[0];
    //const _url = `https://ipfs.infura.io/ipfs/${pathImage}`;
    try{
      const _addFile = await _clinet.add(_file);
      setImageUrl(_addFile.path);
    }catch(e) {
      console.log(`Error in OnChange${e}`)
    }
  }

  const [loadData,setLoadData] = useState(false);
  const [fetchContract,setFetchContract] = useState([]);
  useEffect(()=>{
    const _fetchContract = async () => {
      for(let i = 0 ; i < animalsContract.totalSupply ; i++) {
        const _dataList = await animalsContract.contract.methods.getAnimalsNft().call();
        //const _fetchUploadData = await animalsContract.contract.methods.tokenByIndex(i).call();
        const _fetchUploadData = _dataList[i];
        //console.log(_fetchUploadData);
        setFetchContract(_upload => [..._upload,_fetchUploadData]);
        setLoadData(true);
      }
    }
    animalsContract && _fetchContract();
  },[animalsContract]);


  const _mintFunc = async () => {
    //console.log(fetchContract);
    if(imageUrl === undefined || imageUrl === ''){
      window.alert("No Image Slected");
    } else {
      await animalsContract.contract.methods.mint(`${imageUrl}`).send({from:web3.account});  
      imageUrl = '';
      window.location.reload();
     _providerChange(web3.provider);  
    }
  }


  const _reqAccoubtsFunc = async () => {
    return await web3.web3.eth.requestAccounts();
   }


  return (
    <div>
         <div className="pos-f-t">
            <div className="collapse" id="navbarToggleExternalContent">
              <div className="bg-dark p-4">
              <h4 className="text-white">Collapsed content</h4>
             <span className="text-muted">Toggleable via the navbar brand.</span>
            </div>
           </div>
           <nav className="navbar navbar-dark bg-dark">
              <button className="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarToggleExternalContent" aria-controls="navbarToggleExternalContent" aria-expanded="false" aria-label="Toggle navigation">
               <span className="navbar-toggler-icon"></span>
              </button>
            </nav>
          </div>

          <div><h3>Address: {web3.account}</h3></div>
          <div><h3>Balance: {animalsContract.balanceUser} Ether</h3></div>
          <div><h3>TotalSupply: {animalsContract.totalSupply}</h3></div>

          <div className="input-group mb-3">
              <input type="file" className="custom-file-input" id="inputGroupFile01" onChange={_onChange}/>
              <label className="custom-file-label" for="inputGroupFile01" onChange={_onChange}>Choose file</label>
          </div>

          <div>
            <button onClick={()=>{ !web3.account? _reqAccoubtsFunc():_mintFunc()}}>
              Mint
            </button>
          </div>


          {
        !loadData ? <div>Loading...</div> : fetchContract.map((key,value)=>{
          const _data = `https://ipfs.infura.io/ipfs/${key}`;
          console.log(_data);
          return(
             <div key={key}>
            <div className='container p-3'>
             <div className="card" >
                 <div className="card-body">
                  <img src={_data} height="200px" width="300px"/>
               </div>
             </div>
          </div>
        </div>
          );
        })
      }
    </div>
  );
}
