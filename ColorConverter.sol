// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

/// @title ColorConverter
/// @author @codingwithmanny & @mannynarang
/// @notice Provides multiple functions for converting colors to different formats
library ColorConverter {
    // Constants
    bytes1 constant a = bytes1('a');
    bytes1 constant f = bytes1('f');
    bytes1 constant A = bytes1('A');
    bytes1 constant F = bytes1('F');
    bytes1 constant zero = bytes1('0');
    bytes1 constant nine = bytes1('9');

    /**
     * Code provided by github.com/themandalore - https://ethereum.stackexchange.com/questions/52847/parse-string-into-multiple-variables/53115#53115
     * Convert a character to its hex value as a byte. This is NOT
     * very efficient but is a brute-force way of getting the job done.
     * It's possible to optimize this with assembly in solidity but
     * that would require a lot more time.
     */
    function hexCharToByte(uint8 c) pure internal returns(uint8) {
        bytes1 b = bytes1(c);

        //convert ascii char to hex value
        if(b >= zero && b <= nine) {
            return c - uint8(zero);
        } else if(b >= a && b <= f) {
            return 10 + (c - uint8(a));
        }
        return 10 + (c - uint8(A));
    }

    /**
     * Code provided by github.com/themandalore - https://ethereum.stackexchange.com/questions/52847/parse-string-into-multiple-variables/53115#53115
     * Check whether a string has hex prefix.
     */
    function hasZeroXPrefix(string memory s) pure internal returns(bool) {
        bytes memory b = bytes(s);
        if(b.length < 2) {
            return false;
        }
        return b[1] == 'x';
    }

    /**
     * Code provided by github.com/themandalore - https://ethereum.stackexchange.com/questions/52847/parse-string-into-multiple-variables/53115#53115
     * Assumed that it accepts hex values without #
     */
    function hexToUint(string memory hexValue) pure public returns(uint) {
        //convert string to bytes
        bytes memory b = bytes(hexValue);

        //make sure zero-padded
        require(b.length % 2 == 0, "String must have an even number of characters");

        //starting index to parse from
        uint i = 0;
        //strip 0x if present
        if(hasZeroXPrefix(hexValue)) {
            i = 2;
        }
        uint r = 0;
        for(;i<b.length;i++) {
            //convert each ascii char in string to its hex/byte value.
            uint b1 = hexCharToByte(uint8(b[i]));

            //shift over a nibble for each char since hex has 2 chars per byte
            //OR the result to fill in lower 4 bits with hex byte value.
            r = (r << 4) | b1;
        }
        //result is hex-shifted value of all bytes in input string.
        return r;
    }

    /**
     * Inspired by Java code - unknown url but will find later
     * Converts a decimal value to a hex value without the #
     */
    function uintToHex (uint256 decimalValue) pure public returns (bytes memory) {
        uint remainder;
        bytes memory hexResult = "";
        string[16] memory hexDictionary = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"];

        while (decimalValue > 0) {
            remainder = decimalValue % 16;
            string memory hexValue = hexDictionary[remainder];
            hexResult = abi.encodePacked(hexValue, hexResult);
            decimalValue = decimalValue / 16;
        }
        
        // Account for missing leading zeros
        uint len = hexResult.length;

        if (len == 5) {
            hexResult = abi.encodePacked("0", hexResult);
        } else if (len == 4) {
            hexResult = abi.encodePacked("00", hexResult);
        } else if (len == 3) {
            hexResult = abi.encodePacked("000", hexResult);
        } else if (len == 4) {
            hexResult = abi.encodePacked("0000", hexResult);
        }

        return hexResult;
    }

    /**
     * Inspired by Guffa's math - https://stackoverflow.com/questions/29241442/decimal-to-rgb-in-javascript-and-php/29241510#29241510
     * Returns a value between 0 and 255 for red
     */
    function uintToRGBRed (uint256 decimalValue) pure public returns (uint16) {
        uint red = uint(decimalValue)/(256 * 256);
        return uint16(red);
    }

    /**
     * Inspired by Guffa's math - https://stackoverflow.com/questions/29241442/decimal-to-rgb-in-javascript-and-php/29241510#29241510
     * Returns a value between 0 and 255 for green
     */
    function uintToRGBGreen (uint256 decimalValue) pure public returns (uint16) {
        uint green = uint(decimalValue)/256;
        return uint16(green % 256);
    }

    /**
     * Inspired by Guffa's math - https://stackoverflow.com/questions/29241442/decimal-to-rgb-in-javascript-and-php/29241510#29241510
     * Returns a value between 0 and 255 for blue
     */
    function uintToRGBBlue (uint256 decimalValue) pure public returns (uint16) {
        return uint16(decimalValue % 256);
    }
}