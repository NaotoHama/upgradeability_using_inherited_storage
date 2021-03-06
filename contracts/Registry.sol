pragma solidity >=0.4.0 <0.6.0;

import './IRegistry.sol';
import './Upgradeable.sol';
import './UpgradeabilityProxy.sol';

/**
 * @title Registry
 * @dev This contract works as a registry of versions, it holds the implementations for the registered versions.
 */
contract Registry is IRegistry {
  // Mapping of versions to implementations of different functions
  mapping (string => address) internal versions;

  /**
  * @dev Registers a new version with its implementation address
  * @param version representing the version name of the new implementation to be registered
  * @param implementation representing the address of the new implementation to be registered
  */
  function addVersion(string version, address implementation) external {
    require(versions[version] == address(0x0));
    versions[version] = implementation;
    // emit event
    emit VersionAdded(version, implementation);
  }

  /**
  * @dev Tells the address of the implementation for a given version
  * @param version to query the implementation of
  * @return address of the implementation registered for the given version
  */
  function getVersion(string version) external view returns (address) {
    return versions[version];
  }

  /**
  * @dev Creates an upgradeable proxy
  * @param version representing the first version to be set for the proxy
  * @return address of the new proxy created
  */
  function createProxy(string memory version) public returns (UpgradeabilityProxy) {
    UpgradeabilityProxy proxy = new UpgradeabilityProxy(version);
    Upgradeable(address(proxy)).initialize(msg.sender);
    // emit event
    emit ProxyCreated(address(proxy));
    return proxy;
  }
}
