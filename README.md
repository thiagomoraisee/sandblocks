# SandBlocks
<img src="documentation/images/sandblocks.svg" width="250px" align="left">

Sandblocks is a collection of microelectronic IPs designed for technology exploration and methodology validation in digital design. Each block is modular and self-contained, building a portfolio for seamless integration into ASIC projects.

The main goal of this project is to develop robust, synthesizable microelectronic IP blocks while testing architectural approaches for PPA efficiency, developing auxiliary tools, and exploring configurations for ASIC flows. As a FOSS enthusiast, I'll primarily use (but am not limited to) open-source projects and tools such as [GTKWave](https://gtkwave.sourceforge.net/), [SystemC](https://systemc.org/), and the [SkyWater](https://www.skywatertechnology.com/) PDK. Commercial tools from Cadence and Synopsys may also be used along this journey, as they are industry leaders in the microelectronics field.

Each IP block in this project is designed to be fully self-contained, with a clear and modular structure to facilitate ease of integration and reuse. Each block includes comprehensive documentation, testbenches, and configuration files. This design approach ensures that each IP can function independently, simplifying the process of incorporating it into different projects or testing environments.

## Project Structure

Each IP block in the Sandblocks project follows a directory structure to ensure clarity and maintainability:

```
<block>/       # Example block
├── arch/      # SystemC models (High-level architecture)
├── rtl/       # RTL implementation (Verilog/SystemVerilog)
├── doc/       # Documentation (LaTeX)
├── scripts/   # Environment-specific Makefiles
└── workspace/ # Temporary output and simulation files
```

## One Makefile to rule them all

Every Sandblock is selfcontained and adopts a unified Makefile located in `the scripts/` directory. This approach provides very workflow where users can choose the desired environment (arch, rtl, or doc) and the corresponding action (e.g., run, gui, view).

This atomic structure allows individual development and testing of each environment while maintaining a cohesive and extensible design flow. For example, if you just want to test some systemverilog approach with ModelSim and don't want to use the unified Makefile, you can simply create a symbolic link in the `workspace/` directory (`ln -s ../scripts/Makefile.modelsim Makefile`, considering you are in `workspace/` directory) and perform your experiments.

### initial configuration:

Before using a specific tool, it is recomendded to run the configuration file located in `scripts/`. For example, if you are in `workflow/` and desire to use SystemC/C++ libs run the following script:

```
source ../scripts/config_systemc.sh
```

This command must be run once per session/terminal to ensure the environment variables for properly work with SystemC.

### Usage

To run the unified Makefile, just use the general syntax:

```
make [environment] [target]
```

The available environments are:

- **arch** - Runs Makefile.systemc for architectural (ARCH) modeling/simulation with SystemC;
  
- **rtl** - Runs Makefile.modelsim for RTL modeling/simulation with ModelSim;
  
- **doc** - Runs Makefile.latex for compiling/visualizing the block documentation.

For further details about the commands you can run `make help` in unified Makefile.

### Examples:
`make arch run` - Run ARCH environment;
`make rtl waves` - Open RTL simulation waveform (.vcd) with GTKWave; 
`make rtl gui` - Run RTL simulation with ModelSim GUI; 
`make doc tex` - Compile (.tex) documentation with pdflatex; 
