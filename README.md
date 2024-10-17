# matlabUtilities
MATLAB Utility Functions

## Overview
This repository contains a series of additional utility functions for MATLAB, designed to extend the functionality of standard MATLAB libraries and simplify various tasks. 
These functions aim to help users perform common operations more efficiently and make MATLAB code more readable and maintainable.

# Features

- __Custom Functions__: A collection of MATLAB functions to perform various tasks, such as data manipulation, file handling, mathematical operations, and visualization enhancements.
- __Easy Integration__: All functions are designed to be easily integrated into existing MATLAB projects.

# Getting Started
Prerequisites
Make sure you have a recent version of MATLAB installed. 
These utility functions have been tested with MATLAB R2024b.

## Installation

I always suggest (and I do) to integrate this repository into your existing MATLAB project as a Git submodule.

Add the submodule to your project: In the root directory of your existing Git repository, run the following command to add this repository as a submodule:

```bash
git submodule add https://github.com/delloiaconos/matlabUtilities.git matlabUtilities
```

This will clone the utility functions repository into an ```matlabUtilities``` folder within your project.

Initialize and update the submodule: If you're cloning a project that already uses this submodule, you need to initialize and update it:

```bash
git submodule update --init --recursive
```
Add the submodule path to MATLAB: In your MATLAB code, make sure to add the submodule directory to the MATLAB path to access the utility functions:


```matlab
addpath(genpath('/path/to/matlabUtilities/utilities'));
```
You can also add the directory permanently using the MATLAB ```pathtool``` or ```savepath``` functions.

## Usage
__Basic Examples__: each function comes with an example demonstrating how to use it. You can find these examples in the examples directory.

__Documentation__: Each function has inline comments explaining its purpose, input parameters, and output values. Use MATLAB's help command to access this documentation:

```matlab
help function_name
```
# Related projects
If you're interested in additional MATLAB utilities, you might also find these related projects useful:

__matplotUtilities__: A collection of functions and utilities designed to enhance MATLAB's plotting capabilities. 
This project provides tools for creating custom plots, improving plot aesthetics, and automating repetitive plotting tasks. 
It is ideal for users who want to create high-quality figures for publications or presentations.
Have a look to the GitHub repository [delloiaconos/mplotUtility](https://github.com/delloiaconos/mplotUtility.git).


# License 
This software is distributed under the GNU General Public License (GPL) v3.0, making it freely available for anyone to use, modify, and distribute. 
See the LICENSE file for more details.

## Contributing
Contributions are welcome! If you would like to contribute, please follow these steps:

Fork the repository.
Create a new branch (```git checkout -b feature/your-feature```).
Commit your changes (```git commit -am 'Add some feature'```).
Push to the branch (```git push origin feature/your-feature```).

Create a new pull request.

# Contacts
For any questions, issues, or suggestions, please feel free to open an issue on GitHub or contact the project maintainer: Salvatore Dello Iacono
