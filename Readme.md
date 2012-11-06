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
### Enviroment
#### World
**[SynapticWallBase.pde][]**: This file sets up the environment and delegates all the events to the global [SynapticWall](#synaptic-wall) object and sets up the [Grid](#grid) used to place objects and define paths

#### Synaptic Wall
**[SynapticWall.pde][]**: the controller for all inputs such as mouse interactions and keypress events. It handles state transitions and keeps track of what current mode (creation, deletion, interaction) it's in and determines the result of each input depending on context. It's also responsible for sending interaction events down to the [Object Collection][], the [Grid][], the [Control Panel][], as well as other temporary objects being created.

**[Selector.pde][]**:

**[Collection.pde][]**:
**[ObjectCollection.pde][]**:

**[Grid.pde][]**:

### Control Panel
**[ControlPanel.pde][]**:

**[ControllerSoma.pde][]**:
**[ControllerSynapse.pde][]**:


### Objects
#### Drawable
**[Drawable.pde][]**:
#### Interactive
**[Interactive.pde][]**:
#### Shape
**[Shape.pde][]**:
**[ControllableShape.pde][]**:
#### Cell
**[Cell.pde][]**:
**[Soma.pde][]**:
**[Initiator.pde][]**:

#### Synapse
**[Synapse.pde][]**:

#### Path
**[Path.pde][]**:
**[Axon.pde][]**:
**[Dendrite.pde][]**:

### Controls
#### Controllable
**[Controllable.pde][]**:
#### Slider
**[Control.pde][]**:
**[Slider.pde][]**:
##### Linear Sliders
**[LinearSlider.pde][]**:
**[DoubleEndedSlider.pde][]**:
##### Circular Sliders
**[CircularSlider.pde][]**:
**[DiscreteCircularSlider.pde][]**:
**[ThresholdSlider.pde][]**:

### Utilities

#### Timer
**[Timer.pde][]**:

#### Util Functions
**[Util.pde][]**:

#### Plugins
**[Plugins.pde][]**:
**[Plot.pde][]**:

### Constants
**[Constants.pde][]**:



<!-- Self Links -->

[World]: #world
[Object Collection]: #object-collection
[Grid]: #grid
[Control Panel]: #control-panel

<!-- Files Links -->

[ActionPotential.pde]: /yangsu/Synaptic-Wall/blob/master/ActionPotential.pde
[Axon.pde]: /yangsu/Synaptic-Wall/blob/master/Axon.pde
[Cell.pde]: /yangsu/Synaptic-Wall/blob/master/Cell.pde
[CircularSlider.pde]: /yangsu/Synaptic-Wall/blob/master/CircularSlider.pde
[Collection.pde]: /yangsu/Synaptic-Wall/blob/master/Collection.pde
[Constants.pde]: /yangsu/Synaptic-Wall/blob/master/Constants.pde
[Control.pde]: /yangsu/Synaptic-Wall/blob/master/Control.pde
[ControlPanel.pde]: /yangsu/Synaptic-Wall/blob/master/ControlPanel.pde
[Controllable.pde]: /yangsu/Synaptic-Wall/blob/master/Controllable.pde
[ControllableShape.pde]: /yangsu/Synaptic-Wall/blob/master/ControllableShape.pde
[ControllerSoma.pde]: /yangsu/Synaptic-Wall/blob/master/ControllerSoma.pde
[ControllerSynapse.pde]: /yangsu/Synaptic-Wall/blob/master/ControllerSynapse.pde
[Dendrite.pde]: /yangsu/Synaptic-Wall/blob/master/Dendrite.pde
[DiscreteCircularSlider.pde]: /yangsu/Synaptic-Wall/blob/master/DiscreteCircularSlider.pde
[DoubleEndedSlider.pde]: /yangsu/Synaptic-Wall/blob/master/DoubleEndedSlider.pde
[Drawable.pde]: /yangsu/Synaptic-Wall/blob/master/Drawable.pde
[Grid.pde]: /yangsu/Synaptic-Wall/blob/master/Grid.pde
[Initiator.pde]: /yangsu/Synaptic-Wall/blob/master/Initiator.pde
[Interactive.pde]: /yangsu/Synaptic-Wall/blob/master/Interactive.pde
[LinearSlider.pde]: /yangsu/Synaptic-Wall/blob/master/LinearSlider.pde
[ObjectCollection.pde]: /yangsu/Synaptic-Wall/blob/master/ObjectCollection.pde
[Path.pde]: /yangsu/Synaptic-Wall/blob/master/Path.pde
[Plot.pde]: /yangsu/Synaptic-Wall/blob/master/Plot.pde
[Plugins.pde]: /yangsu/Synaptic-Wall/blob/master/Plugins.pde
[PostsynapticPotential.pde]: /yangsu/Synaptic-Wall/blob/master/PostsynapticPotential.pde
[Selector.pde]: /yangsu/Synaptic-Wall/blob/master/Selector.pde
[Shape.pde]: /yangsu/Synaptic-Wall/blob/master/Shape.pde
[Signal.pde]: /yangsu/Synaptic-Wall/blob/master/Signal.pde
[SignalVisualizer.pde]: /yangsu/Synaptic-Wall/blob/master/SignalVisualizer.pde
[Signalable.pde]: /yangsu/Synaptic-Wall/blob/master/Signalable.pde
[Slider.pde]: /yangsu/Synaptic-Wall/blob/master/Slider.pde
[Soma.pde]: /yangsu/Synaptic-Wall/blob/master/Soma.pde
[Synapse.pde]: /yangsu/Synaptic-Wall/blob/master/Synapse.pde
[SynapticWall.pde]: /yangsu/Synaptic-Wall/blob/master/SynapticWall.pde
[SynapticWallBase.pde]: /yangsu/Synaptic-Wall/blob/master/SynapticWallBase.pde
[ThresholdSlider.pde]: /yangsu/Synaptic-Wall/blob/master/ThresholdSlider.pde
[Timer.pde]: /yangsu/Synaptic-Wall/blob/master/Timer.pde
[Util.pde]: /yangsu/Synaptic-Wall/blob/master/Util.pde