export default class Web3utils {
  public static tokens(n: any) {
    return web3.utils.toWei(n, "ether");
  }
}
