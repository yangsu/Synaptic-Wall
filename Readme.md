# Synaptic Wall Project

## Instructions
* Press *1* to switch to _Creation_ mode. Click to create a soma. Click and drag existing somas to change their location. Click on the outer ring around a Soma to change it's threshold level. 
* Press *2* to switch to _Deletion_ mode. Click to delete (*not implemented*)
* Press *3* to switch to _Interaction_ mode. Click and drag on the sliders to change properties. Click on empty areas to create selection boxes. When at least one object is selected, the control panel that can control all corresponding elements in the selection
* Press *m* to show a zoom lense, move the mouse around to move the focus of the lense
* Press *p* to pause rendering
* Press *o* to resume rendering
* Press *c* to clear the screen

---

## Design

### Enviroment
#### [SynapticWallBase.pde][]
This file sets up the environment and delegates all the events to the global [SynapticWall][] object and sets up the [Grid][] used to place objects and define paths

#### [SynapticWall.pde][]
The controller for all inputs such as mouse interactions and keypress events. It handles state transitions and keeps track of what current mode (creation, deletion, interaction) it's in and determines the result of each input depending on context. It's also responsible for sending interaction events down to the [ObjectCollection][], the [Grid][], the [ControlPanel][], as well as other temporary objects being created.

#### [Selector.pde][]
An utility object that keeps the state, renders, and provide information about the selection rectangle

#### [Grid.pde][]
Geometric Grid used for positioning objects in the world with constraints in order to have geometric appeareances and properties

#### [Constants.pde][]
All constants used for rendering or calculations are defined within this file. It's then made available to all objects through inheritance. Some constants can be recalculated based on a scale constant

---

### Objects

#### [Drawable.pde][]
*Abstract* class that extends [Constants][] that keeps track for basic information such as location, color, creation time, and flags such as Visible and Movable

#### [Interactive.pde][]
*Abstract* class that extends [Drawable][] that defines the methods used for handling events and interactions with default implementations

#### [Shape.pde][]
*Abstract* Class that extends [Interactive][] that provides methods for adjusting locations of objects

##### [ControllableShape.pde][]
*Abstract* Class that extends [Shape][] that contains default behavior for shapes that have controls

#### [Cell.pde][]
*Abstract* Class that extends [ControllableShape][] that outlines how Shapes interact with [Paths][Path] and fire signal

##### [Soma.pde][]
Class that extends [Cell][] that contains Soma specific behavior and rendering, such as the decay of the Soma's potential and how [Action Potentials][ActionPotential] are fired

##### [Initiator.pde][]
Class that extends [Cell][] that contains Initiator specific behavior and   rendering, such as how [Post Synaptic Potentials][PostsynapticPotential] are generated and the parameters that control the firing behavior of the cell

#### [Synapse.pde][]
Class that extends [ControllableShape][] that specifies how a Synapse updates its appearance and state based on its firing timer

#### [Path.pde][]
*Abstract* Class that extends [Interactive][] that details how Paths ([Axons][Axon] and [Dendrites][Dendrite]) process signals, junctions, and events 

##### [Axon.pde][]
Class that extends [Path][] that contains Axon specific behavior logic and rendering code

##### [Dendrite.pde][]
Class that extends [Path][] that contains Dendrite specific behavior logic and rendering code

#### [Collection.pde][]
A class that contains methods for adding or removing items from the collection, event handling, selection, and rendering

##### [ObjectCollection.pde][]
The collection that keeps track of all the primary objects ([Soma][], [Initiator][], [Dendrite][], [Axon][], [Synapse][]) in Synaptic Wall

---

### Controls

#### [Control.pde][]
*Abstract* Class that extends [Interactive][] that contains fields required for Control objects

#### [Controllable.pde][]
Interface that defines how objects can interact with Controllable objects

#### [Slider.pde][]
Slider UI element that maps a value within a range

##### [LinearSlider.pde][]
A simple rectangular [Slider][] that maps values along the x axis

##### [CircularSlider.pde][]
A circular [Slider][] that maps values to radian angles

###### [DiscreteCircularSlider.pde][]
A [CircularSlider][] that allows only integer values

###### [DoubleEndedSlider.pde][]
A [CircularSlider][] that allows a range of values instead of a single particular value on the slider

###### [ThresholdSlider.pde][]
A [CircularSlider][] that's used to represent a Cell's firing potential

---

### Control Panel
#### [ControlPanel.pde][]
A object that encapsulates the objects in the Control Panel on the right side of the app and manages its behavior in response to control adjustments and interactions

#### [ControllerSoma.pde][]
A [Soma][] SubClass that's used to display special information in the [Control Panel][ControlPanel]

#### [ControllerSynapse.pde][]
A [Synapse][] SubClass that's used to display special information in the [Control Panel][ControlPanel]


---

### Utilities

#### [Timer.pde][]
A timer object that can fire an event at a particular point in the future

#### [Util.pde][]
A collection of utility functions that are used throughout the code base to do computation

#### [Plugins.pde][]
Processing plugin functions that provide functions to draw shapes such as arcs and rings

#### [Plot.pde][]

---

<!-- Nav Links -->

[SynapticWallBase]: #synapticwallbasepde
[SynapticWall]: #synapticwallpde
[Selector]: #selectorpde
[Collection]: #collectionpde
[ObjectCollection]: #objectcollectionpde
[Grid]: #gridpde
[ControlPanel]: #controlpanelpde
[ControllerSoma]: #controllersomapde
[ControllerSynapse]: #controllersynapsepde
[Drawable]: #drawablepde
[Interactive]: #interactivepde
[Shape]: #shapepde
[ControllableShape]: #controllableshapepde
[Cell]: #cellpde
[Soma]: #somapde
[Initiator]: #initiatorpde
[Synapse]: #synapsepde
[Path]: #pathpde
[Axon]: #axonpde
[Dendrite]: #dendritepde
[Controllable]: #controllablepde
[Control]: #controlpde
[Slider]: #sliderpde
[LinearSlider]: #linearsliderpde
[DoubleEndedSlider]: #doubleendedsliderpde
[CircularSlider]: #circularsliderpde
[DiscreteCircularSlider]: #discretecircularsliderpde
[ThresholdSlider]: #thresholdsliderpde
[Timer]: #timerpde
[Util]: #utilpde
[Plugins]: #pluginspde
[Plot]: #plotpde
[Constants]: #constantspde
[ActionPotential]: #actionpotentialpde
[PostsynapticPotential]: #postsynapticpotentialpde
[Signal]: #signalpde
[SignalVisualizer]: #signalvisualizerpde
[Signalable]: #signalablepde

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