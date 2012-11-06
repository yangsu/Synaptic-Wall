# Synaptic Wall Project

## Instructions
* Press *1* to switch to _Creation_ mode. Click to create a soma. Click and drag existing somas to change their location. Click on the outer ring around a Soma to change it's threshold level. 
* Press *2* to switch to _Deletion_ mode. Click to delete (*not implemented*)
* Press *3* to switch to _Interaction_ mode. Click and drag on the sliders to change properties. Click on empty areas to create selection boxes. When at least one object is selected, the control panel that can control all corresponding elements in the selection
* Press *m* to show a zoom lense, move the mouse around to move the focus of the lense
* Press *p* to pause rendering
* Press *o* to resume rendering
* Press *c* to clear the screen

## Design
### World
**[SynapticWallBase.pde](/blob/master/SynapticWallBase.pde)**: This file sets up the environment and delegates all the events to the global [SynapticWall](#synaptic-wall) object and sets up the [Grid](#grid) used to place objects and define paths

### Synaptic Wall