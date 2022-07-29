// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// NFT token interface
// To store images people usually use IPFS(inter-planet file system, like torrent). For example service Pinata.

interface IERC721 {
    event Transfer(address indexed from, address indexed to, uint indexed tokenId);
    
    // some 'approved' is allowed to interact with my NFT
    event Approval(address indexed owner, address indexed approved, uint indexed tokenId);

    // some 'operator' is allowed to interact with all of my NFTs 
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function balanceOf(address owner) external view returns(uint);

    function ownerOf(uint tokenId) external view returns(address);

    // function to transfer NFT between 2 addresses in more safer way
    function safeTransferFrom(address from, address to, uint tokenId) external;

    // same function as above but with extra argument 'data'
    // function safeTransferFrom(address from, address to, uint tokenId, bytes calldata data) external;

    function transferFrom(address from, address to, uint tokenId) external;

    function approve(address to, uint tokenId) external;

    function setApprovalForAll(address operator, bool approved) external;

    // who are allowed to interact with NFT
    function getApproved(uint tokenId) external view returns(address);

    function isApprovedForAll(address owner, address operator) external view returns(bool);
}