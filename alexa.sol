pragma solidity 0.5.16;

interface IBEP20 {
    function totalSupply() external view returns (uint256);

    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    function getOwner() external view returns (address);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address _owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Context {
    
    constructor () internal { }

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
        return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract BEP20Token is Context, IBEP20, Ownable {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    mapping (string => address) public _tokenDistributionMapping;

    uint256 private _totalSupply;

    uint256 private _marketingTotalSupply;
    uint256 private _marketingCurrentSupply;
    
    uint256 private _seedTotalSupply;
    uint256 private _seedCurrentSupply;

    uint256 private _insuranceTotalSupply;
    uint256 private _insuranceCurrentSupply;

    uint256 private _productDevelopmentTotalSupply;
    uint256 private _productDevelopmentCurrentSupply;

    uint256 private _liquidityProvidersTotalSupply;
    uint256 private _liquidityProvidersCurrentSupply;

    uint8 private _decimals;
    string private _symbol;
    string private _name;
    address public _owner;

    address public _seedAddress;
    address public _insuranceAddress;
    address public _liquidityProviderAddress;
    address public _productDevelopmentAddress;

    constructor() public {
        _name = "ALEXA";
        _symbol = "ALEXA";
        _decimals = 18;

        _tokenDistributionMapping["SEED"] = 0x506f70b1C42d0fdc123506853650851d0abbF652;
        _tokenDistributionMapping["INSURANCE"] = 0x4ee5E86831837204C588042A9aAc0f07F5014266;
        _tokenDistributionMapping["LIQUIDITY_PROVIDERS"] = 0x8782DbaDE3556B14970b9F3757D799c9535F24DE;
        _tokenDistributionMapping["PRODUCT_DEVELOPMENT"] = 0xF4773419713f2ac411C9104575dd0980E2F9a077;

        _totalSupply = 10 * 1000 * 1000 * 1000 * 10 ** 18;

        _marketingCurrentSupply = 0;
        _productDevelopmentCurrentSupply = 0;
        _seedCurrentSupply = 0;
        _insuranceCurrentSupply = 0;
        _liquidityProvidersCurrentSupply  = 0;

        _owner = msg.sender; 

        emit Transfer(address(0), msg.sender, _marketingCurrentSupply);
    }

    function getOwner() external view returns (address) {
        return owner();
    }

    function decimals() external view returns (uint8) {
        return _decimals;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function name() external view returns (string memory) {
        return _name;
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) external returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) external view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "BEP20: transfer from the zero address");
        require(recipient != address(0), "BEP20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "BEP20: burn from the zero address");

        _balances[account] = _balances[account].sub(amount, "BEP20: burn amount exceeds balance");
        emit Transfer(account, address(0), amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "BEP20: burn amount exceeds allowance"));
    }

    function updateTotalSupply(uint256 amount) public {
        require(msg.sender == _owner, "Only owner can update total supply.");

        _totalSupply = _totalSupply.add(amount);
    }
    
    function mintViaMarketing(address to, uint256 amount) public {
        _marketingTotalSupply = _totalSupply * 24 / 100;

        require(_marketingTotalSupply >= _marketingCurrentSupply.add(amount), "Marketing supply finished.");
        require(msg.sender == _owner, "Only owner can mint coins.");

        _mintViaMarketing(to, amount);
    }

    function _mintViaMarketing(address account, uint256 amount) internal {
        require(account != address(0), "BEP20: mint to the zero address");

        _marketingCurrentSupply = _marketingCurrentSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function getCurrentMintMarketingSupply() external view returns (uint256) {
        return _marketingCurrentSupply;
    }

    function mintSeed(uint256 amount) public {
        _seedAddress = _tokenDistributionMapping["SEED"];
        _seedTotalSupply = _totalSupply * 2 / 100;

        require(_seedAddress != address(0), "BEP20: mint to the zero address");
        require(_seedTotalSupply >= _seedCurrentSupply.add(amount), "Seed supply finished.");
        require(msg.sender == _owner, "Only owner can mint coins.");

        _seedCurrentSupply = _seedCurrentSupply.add(amount);
        _balances[_seedAddress] = _balances[_seedAddress].add(amount);
        emit Transfer(address(0), _seedAddress, amount);
    }

    function getCurrentMintSeedSupply() external view returns (uint256) {
        return _seedCurrentSupply;
    }

    function mintInsurance(uint256 amount) public {
        _insuranceAddress = _tokenDistributionMapping["INSURANCE"];
        _insuranceTotalSupply = _totalSupply * 10 / 100;

        require(_insuranceAddress != address(0), "BEP20: mint to the zero address");
        require(_insuranceTotalSupply >= _insuranceCurrentSupply.add(amount), "Insurance supply finished.");
        require(msg.sender == _owner, "Only owner can mint coins.");

        _insuranceCurrentSupply = _insuranceCurrentSupply.add(amount);
        _balances[_insuranceAddress] = _balances[_insuranceAddress].add(amount);
        emit Transfer(address(0), _insuranceAddress, amount);
    }

    function getCurrentMintInsuranceSupply() external view returns (uint256) {
        return _insuranceCurrentSupply;
    }
    
    function mintLiquidityProvider(uint256 amount) public {
        _liquidityProviderAddress = _tokenDistributionMapping["LIQUIDITY_PROVIDERS"];
        _liquidityProvidersTotalSupply = _totalSupply * 40 / 100;

        require(_liquidityProviderAddress != address(0), "BEP20: mint to the zero address");
        require(_liquidityProvidersTotalSupply >= _liquidityProvidersCurrentSupply.add(amount), "Liquidity provider supply finished.");
        require(msg.sender == _owner, "Only owner can mint coins.");

        _liquidityProvidersCurrentSupply = _liquidityProvidersCurrentSupply.add(amount);
        _balances[_liquidityProviderAddress] = _balances[_liquidityProviderAddress].add(amount);
        emit Transfer(address(0), _liquidityProviderAddress, amount);
    }
    
    function getCurrentMintLiquidityProviderSupply() external view returns (uint256) {
        return _liquidityProvidersCurrentSupply;
    }

    function mintProductDevelopment(uint256 amount) public {
        _productDevelopmentAddress = _tokenDistributionMapping["PRODUCT_DEVELOPMENT"];
        _productDevelopmentTotalSupply = _totalSupply * 24 / 100;

        require(_productDevelopmentAddress != address(0), "BEP20: mint to the zero address");
        require(_productDevelopmentTotalSupply >= _productDevelopmentCurrentSupply.add(amount), "Product development supply finished.");
        require(msg.sender == _owner, "Only owner can mint coins.");

        _productDevelopmentCurrentSupply = _productDevelopmentCurrentSupply.add(amount);
        _balances[_productDevelopmentAddress] = _balances[_productDevelopmentAddress].add(amount);
        emit Transfer(address(0), _productDevelopmentAddress, amount);
    }

    function getCurrentMintProductDevelopmentSupply() external view returns (uint256) {
        return _productDevelopmentCurrentSupply;
    }
}
