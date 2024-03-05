// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;


contract UserManagement {

    enum UserRole{ADMIN, MANAGER, USER}

    struct User {
        string name;
        UserRole role;
    }

    constructor() {
        userList[msg.sender] = User({name: "ADMIN", role: UserRole.ADMIN});
    }

    mapping(address => User) private userList;

    modifier OnlyAdmin {
        require(userList[msg.sender].role == UserRole.ADMIN, "Only admin can do this function");
        _;
    }

    function addUser(string memory _userName) public OnlyAdmin {
        require(!isUserExist(), "User already existed");
        userList[msg.sender] = User({name: _userName, role: UserRole.USER});
    }

    function isValidRole(UserRole _role) public view returns(bool) {
        require(isUserExist(), "User not found");
        return userList[msg.sender].role == _role;
    }

    function isUserExist() internal view returns(bool) {
        return bytes(userList[msg.sender].name).length > 0;
    }

}

contract FinancialOperation is UserManagement {
    
    mapping(address => uint256) private userFundList;

    modifier OnlyUser {
        require(isUserExist() && isValidRole(UserRole.USER), "Only role User can do this function");
        _;
    }

    // function deposit() public payable OnlyUser {
    //     require(msg.value > 0, "Amount need greater than 0");
    //     userFundList[msg.sender] += msg.value;
    // }

    function withdraw(uint256 _amount) public OnlyUser {
        uint256 totalBalance = address(this).balance;
        require(_amount > 0, "Amount withdraw must greater than 0");
        require(totalBalance >= _amount, "Exceed the balance");

        (bool _success, ) = msg.sender.call{value: _amount}("");
        require(_success, "Withdraw failed");
    }

    fallback() external payable {
        userFundList[msg.sender] += msg.value;
    }

    receive() external payable {
        userFundList[msg.sender] += msg.value;
    }
}