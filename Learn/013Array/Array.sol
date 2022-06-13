// Array

// Array can have a compile-time fixed size or a dynamic size.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Array {
    // Several ways to initialize an array
    uint[] public arr; //storage array, stored on blockchain (dynamic size)
    uint[] public arr2 = [1, 2, 3]; //storage array (dynamic size)
    // Fixed sized array, all elements initialize to 0
    uint[10] public myFixedSizeArr; //storage array (fixed size)

    
  
    function get(uint i) public view returns (uint) {
        return arr[i];
    }

    // Solidity can return the entire array.
    // But this function should be avoided for
    // arrays that can grow indefinitely in length.
    function getArr() public view returns (uint[] memory) {
        return arr;
    }

    function get2(uint i) public view returns (uint) {
        return arr2[i];
    }

    function getArr2() public view returns (uint[] memory) {
        return arr2;
    }

    function pushToArr(uint i) public {
        // Append to array
        // This will increase the array length by 1.
        arr.push(i);
        
    }

    function pushToArr2(uint i) public {
        // Append to array
        // This will increase the array length by 1.
        arr2.push(i);
        
    }

    function assignFixedSizeArr() public payable returns (uint[10] memory){  
        myFixedSizeArr = [uint(10), 20, 30, 40, 50, 60, 70, 80, 90, 100];
        return myFixedSizeArr;  
  }  

    function popFromArr() public {
        // Remove last element from array
        // This will decrease the array length by 1
        arr.pop();
    }

    function popFromArr2() public {
        // Remove last element from array
        // This will decrease the array length by 1
        arr2.pop();
    }


    function getLength() public view returns (uint, uint, uint) {
        return (arr.length, arr2.length, myFixedSizeArr.length);
    }

    function remove(uint index) public {
        // Delete does not change the array length.
        // It resets the value at index to it's default value,
        // in this case 0
        delete arr[index]; //delete is a unary operator
    }

    function examples() external pure returns (uint[] memory, uint[3] memory, bytes memory){
        uint len = 7;
        // create array in memory, only fixed size can be created
        uint[] memory a = new uint[](5);  //memory array (only fixed size, not stored on blockchain)
        a[4] = 8;
        // a[5] = 10;
        // a[6] = 20;
        uint[3] memory b;  //static array
        bytes memory c = new bytes(len);  //bytes is same as byte[]
        b = [uint(10), 20, 30]; 
        return (a, b, c);
    }
}

// A dynamic array is similar to an array but it's size is dynamic and
//  so it will grab more memory when it is full and you add a new element to it. 
// They can be created on the stack or on the heap. 

// vs.

// A dynamically allocated array is simply an array that is created on the heap.
 


// Contract in Solidity is similar to a Class in C++. A Contract have following properties.

// Constructor − A special function declared with constructor keyword which will be executed once per contract and is invoked when a contract is created.

// State Variables − Variables per Contract to store the state of the contract.

// Functions − Functions per Contract which can modify the state variables to alter the state of a contract.

// Visibility Quantifiers
// Following are various visibility quantifiers for functions/state variables of a contract.

// external − External functions are meant to be called by other contracts. They cannot be used for internal call. To call external function within contract this.function_name() call is required. State variables cannot be marked as external.

// public − Public functions/ Variables can be used both externally and internally. For public state variable, Solidity automatically creates a getter function.

// internal − Internal functions/ Variables can only be used internally or by derived contracts.

// private − Private functions/ Variables can only be used internally and not even by derived contracts.
      
    
contract DynamicArray{
    
// Declaring state variable  
int[] private arr; //It will not show publicly, privately stored
// Function to add data 
// in dynamic array
function addData(int num) public
{
  arr.push(num);
}
      
// Function to get data of
// dynamic array
function getData() public view returns(int[] memory)
{
  return arr;
}
      
// Function to return length 
// of dynamic array
function getLength() public view returns (uint)
{
  return arr.length;
}
  
// Function to return sum of 
// elements of dynamic array
function getSum() public view returns(int)
{
  uint i;
  int sum = 0;
    
  for(i = 0; i < arr.length; i++)
    sum = sum + arr[i];
  return sum;
}
      
// Function to search an 
// element in dynamic array
function search(int num) public view returns (bool)
{
  uint i;
    
  for(i = 0; i < arr.length; i++)
  {
    if(arr[i] == num)
    {
      return true;
    }
  }
    
  if(i >= arr.length)
    return false;
}
}

// Storage vs. Memory

// Creating a contract
contract Storage
{
  // Initialising array numbers
  int[] public numbers;
 
  // Function to insert values
  // in the array numbers
  function Numbers() public
  {
    numbers.push(1);
    numbers.push(2);
 
    //Creating a new instance
    int[] storage myArray = numbers;
     
    // Adding value to the
    // first index of the new Instance
    myArray[0] = 0;
  } 
}

// Output:
// When we retrieve the value of the array numbers in the above code, 
// Note that the output of the array is [0,2] and not [1,2]. 

// Creating a contract
contract Memory
{ 
  // Initialising array numbers
  int[] public numbers;
   
  // Function to insert
  // values in the array
  // numbers
  function Numbers() public
  {
    numbers.push(1);
    numbers.push(2);
     
    //creating a new instance
    int[] memory myArray = numbers;
     
    // Adding value to the first
    // index of the array myArray
    myArray[0] = 0;
  } 
}

// Output:
// When we retrieve the value of the array numbers in the above code, Note that the output of the array is [1,2]. 
// In this case, changing the value of myArray does not affect the value in the array numbers.


