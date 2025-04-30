#include "BookingSystem.h"
#include <string>
#include <iostream>
#include <iomanip>

using namespace std;

BookingSystem::BookingSystem {
private:
  string name;
  unsigned int totalWindowsLaptops;
  unsigned int totalMacBooks;
  unsigned int availableWindowsLaptops;;
  unsigned int availableMacBooks;
  unsigned int availableLaptops;
  unsigned int rentedWindowsLaptops;
  unsigned int rentedMacBooks;
  unsigned int rentedLaptops;
 
public:
  BookingSystem(){  //default constructor
    name = "Trinity Laptop Bookings";
    totalWindowsLaptops = 20;
    totalMacBooks = 20;
    availableWindowsLaptops = totalWindowsLaptops;
    availableMacBooks = totalMacBooks;
    availableLaptops = totalWindowsLaptops + totalMacBooks;
    rentedWindowsLaptops = 0;
    rentedMacBooks = 0; 
    rentedLaptops = rentedWindowsLaptops + rentedMacBooks;
    
  }

  BookingSystem(string bookingname, int bookingtotalWindowsLaptops, int bookingtotalMacBooks){ //overloaded constructor
    name = getName(bookingname);
    totalWindowsLaptops = getTotalWindowsLaptops(bookingtotalWindowsLaptops);
    totalMacBooks = getTotalMacBooks(bookingtotalMacBooks);

  
    availableWindowsLaptops = getAvailableWindowsLaptops(totalWindowsLaptops);
    availableMacBooks = getAvailableMacBooks(totalMacBooks);
    availableLaptops = getAvailableLaptops(availableWindowsLaptops, availableMacBooks);

    rentedWindowsLaptops = 0;
    rentedMacBooks = 0;

  }

  bool RentWindowsLaptop(){
    if (availableWindowsLaptops > 0) {
      removeWindowsLaptops();
      rentedWindowsLaptops = getRentedWindowsLaptops();
      rentedLaptops = getRentedLaptops(rentedWindowsLaptops, rentedMacBooks);
      return true; }
    else 
      return false;
  }

  bool RentMacBook(){
    if (availableMacBooks > 0) {
      removeMacBooks();
      rentedMacBooks = getRentedMacBooks();
      rentedLaptops = getRentedLaptops(rentedWindowsLaptops, rentedMacBooks);
      return true; }
    else 
      return false;
  }

  void ReturnWindowsLaptop(){
    if (availableWindowsLaptops < totalWindowsLaptops)
      addWindowsLaptops();
  }

  void ReturnMacBook(){
    if (availableMacBooks < totalMacBooks)
      addMacBooks();
  
  }

  string getName(string name){
    string NewName;
    NewName = name.substr(0, 64);
    return NewName;
  }

  unsigned int getTotalWindowsLaptops(int WindowsLaptops){
   if (WindowsLaptops < 0) 
      WindowsLaptops = 0;
    return WindowsLaptops;
  }

  unsigned int getTotalMacBooks(int MacBooks) {
    if (MacBooks < 0)
      MacBooks = 0;
      return MacBooks;
  }

  unsigned int getAvailableWindowsLaptops(int totalWindowsLaptops){
    int availableWindowsLaptops = totalWindowsLaptops;
    return availableWindowsLaptops;
  }

  unsigned int getAvailableMacBooks(int totalMacBooks) {
    int availableMacBooks = totalMacBooks;
    return availableMacBooks;
  }

  unsigned int getAvailableLaptops(int availableWindowsLaptops, int availableMacBooks){
    availableLaptops = availableWindowsLaptops + availableMacBooks;
    return availableLaptops;
  }

  unsigned int getRentedWindowsLaptops(){
    return rentedWindowsLaptops += 1;
  }

  unsigned int getRentedMacBooks() {
    return rentedMacBooks += 1;
  }

  unsigned int getRentedLaptops(int rentedWindowsLaptops, int rentedMacBooks){
    return rentedWindowsLaptops + rentedMacBooks;
  }

  void addWindowsLaptops() {
    availableWindowsLaptops += 1;
    availableLaptops += 1;
    rentedWindowsLaptops -= 1;
    rentedLaptops -= 1;
  }

  void addMacBooks() {
    availableMacBooks += 1;
    availableLaptops += 1;
    rentedMacBooks -= 1;
    rentedLaptops -= 1;
  }

  void removeWindowsLaptops() {
    availableWindowsLaptops -= 1;
    availableLaptops -= 1;
  }

  void removeMacBooks() {
    availableMacBooks -= 1;
    availableLaptops -= 1;
  }

  void PrintReport(){
    cout << "---------------------" << endl << "Laptop Booking System" << endl << "---------------------" << endl;
    cout << "Name" << setw(22) << left << ":" << " " << name << endl;
    cout << "Total Windows Laptops" << setw(5) << left << ":" << " " << totalWindowsLaptops << endl;
    cout << "Total MacBooks" << setw(12) << left << ":" << " " << totalMacBooks << endl;
    cout << "Rented Windows Laptops" << setw(4) << left << ":" << " " << rentedWindowsLaptops << endl;
    cout << "Rented MacBooks" << setw(11) << left << ":" << " " << rentedMacBooks << endl;
    cout << "Rented Laptops" << setw(12) << left << ":" << " " << rentedLaptops << endl;
    cout << "Available Windows Laptops" << setw(1) << left << ":" << " " << availableWindowsLaptops << endl;
    cout << "Available MacBooks" << setw(8) << left << ":" << " " << availableMacBooks << endl;
    cout << "Available Laptops" << setw(9) << left << ":" << " " << availableLaptops;
  }
};
#endif // BOOKINGSYSTEM_H

/*string name, int totalWindowsLaptops, int totalMacBooks, int rentedWindowsLaptops, int rentedMacBooks, int rentedLaptops, int availableWindowsLaptops, int availableMacBooks, int availableLaptops*/
