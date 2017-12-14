# Topics in Visualization: Homework 2 Wind Visualization
###### Authors: Ayoub Belemlih, Paul Chery
###### Date: 15 December 2017

##Visualization parameters:
Number of particles: 3000
With a stroke weight of 3, 3000 particles shows enough particle to get an understanding of the direction of most of the vectors in the vector field. A lower number of particles does not provide enough information while a higher number of particles leads to visual clutter. 

Particle lifetime: 200
A lifetime of 200 gives enough time for particles to get stuck in some of the vortices or points where the wind vectors are near zero. A smaller lifetime is not enough time for particles to get trapped in these features and thus does not appropriately portray the vector field. A greater lifetime leads to too much visual clutter to see where the particles are heading. 

Step size: 0.1
A smaller step size (e.g. 0.01) is too slow to perceive the flow of the particles in a particular direction given by the vector field. A larger step size (e.g. 1) is too fast and not precise enough to visualize the discrete steps that the particle takes along a given path in the vector field. 

##Discussion of step size:
The step size affects the speed of the particles and the "resolution" of the particle paths. A very low step size will yield a better, more realistic result since the integration is performed at finer intervals while a large step size will yield a rough approximation of the particle trajectories. For large step sizes, the particle will make large jumps quickly and roughly and you only get the general direction of the particle. Small step sizes will lead the particle to follow a precise path. 


##For lack of time, no wizardly work was completed.