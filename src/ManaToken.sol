pragma solidity >=0.8.0;

import { ERC20PresetMinterPauser } from "openzeppelin-contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";


contract ManaToken is ERC20PresetMinterPauser {
    constructor() ERC20PresetMinterPauser("ManaToken", "MANA") {
        this;
    }
}
