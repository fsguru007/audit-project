// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IERC20.sol";

contract Airdrop {
    bool entered;

    modifier reenterencyGaurd {
        require(entered == false, "Reenterancy Gaurd");
        entered = true;
        _;
        entered = false;
    }

    function airdropToken(
        address _token,
        address[] calldata _receivers,
        uint256[] calldata _amounts
    ) external {
        require(_receivers.length == _amounts.length, "_receivers.length not the same as _amounts.length");        
        for (uint256 i; i < _receivers.length; i++) {
            require(IERC20(_token).transferFrom(tx.origin, _receivers[i], _amounts[i]), "Token send failed");
        }
    }

    function airdropMatic(address payable[] calldata _receivers, uint256[] calldata _amounts) external payable reenterencyGaurd {
        require(_receivers.length == _amounts.length, "_receivers.length not the same as _amounts.length");
        uint256 sum;
        for (uint256 i; i < _receivers.length; i++) {
            require(_amounts[i] > 0);
            _receivers[i].transfer(_amounts[i]);
            sum += _amounts[i];
        }
        require(msg.value == sum, "msg.value mismatch");
    }
}
