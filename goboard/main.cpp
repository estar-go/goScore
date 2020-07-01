//
// Created by Kaihua Li on 2020/7/1.
//
#include <iostream>

int main(int argc, char *argv[]) {
    for (int i = 0; i < argc; i++) {
        std::cout << "argument[" << i << "] is: " << argv[i] << std::endl;
    }
    system("pause");
}