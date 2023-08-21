// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface Turnstile {
    function register(address) external returns(uint256);
}

contract ClusterRegistry {
    uint256 private latestClusterId;
    mapping(uint256 => string) private clusterNames;
    mapping(string => uint256) private clusterIds;
    mapping(uint256 => address) private clusterReceivingAddresses;
    mapping(uint256 => uint256) private clusterRanks;

    Turnstile turnstile = Turnstile(0xEcf044C5B4b867CFda001101c617eCd347095B44);

    event ClusterRegistered(uint256 indexed clusterId, string clusterName, address receivingAddress);
    event ClusterReceivingAddressUpdated(uint256 indexed clusterId, address receivingAddress);

    constructor() {
        turnstile.register(tx.origin);
    }

    function register(string memory name) external {
        require(bytes(name).length > 0, "Cluster name cannot be empty.");
        require(clusterIds[name] == 0, "Cluster name is already taken.");

        latestClusterId++;
        clusterNames[latestClusterId] = name;
        clusterIds[name] = latestClusterId;
        clusterReceivingAddresses[latestClusterId] = msg.sender;
        clusterRanks[latestClusterId] = latestClusterId;

        emit ClusterRegistered(latestClusterId, name, msg.sender);
    }

    function changeReceivingAddress(uint256 id, address newReceivingAddress) external returns (address) {
        require(id > 0 && id <= latestClusterId, "Invalid cluster ID.");
        require(msg.sender == clusterReceivingAddresses[id], "Not Receiving Address");

        clusterReceivingAddresses[id] = newReceivingAddress;

        emit ClusterReceivingAddressUpdated(id, newReceivingAddress);
        return newReceivingAddress;
    }

    function getClusterByID(uint256 id) external view returns (string memory) {
        require(id > 0 && id <= latestClusterId, "Invalid cluster ID.");
        return clusterNames[id];
    }

    function getHighestClusterID() external view returns (uint256) {
        return latestClusterId;
    }

    function getIdByClusterName(string memory name) external view returns (uint256) {
        return clusterIds[name];
    }

    function getReceivingAddress(uint256 id) external view returns (address) {
        require(id > 0 && id <= latestClusterId, "Invalid cluster ID.");
        return clusterReceivingAddresses[id];
    }
}
