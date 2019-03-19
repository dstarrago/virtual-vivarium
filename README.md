# artificial-vivarium

A simulated playground where artificial creatures grow and reproduce in order to test the principles of intelligent behavior

This was an Artificial Life project developed in 1998 in Borland Delphi for Microsoft Windows. The component package SimToolsPackage includes components that allow visual design of the arena where the simulation takes places. The visual components are 
- Creature: artificial life entity
- Substrate: food patch that can be eaten by the creatures
- Wall: imposes a physical barrier limiting the geometry of the space where the creatures live
The package should be installed on the IDE to enable full visual design capability.

In the simulated world, each object has position, size, and image. The creatures are also objects of this world. Their bodies can have one o more segments, and their physiology include the following systems:
- Digestive system: transforms food in energy. All systems need energy to work.
- Immune System: takes care of the creature's inmunology, allowing -for example- healling from poisonous food.
- Motor System: allows for movements of rotation and translation
- Reproductive system: allows the reproduction of the creature. Asexual reproduction (bipartition) is implemented so far.
- Nervous system: allows the organism to react and take decisions to maximize the chance to survive.
- Metabolism: controls the relation among hungriness, energy, health, and reproduction.
- Growth system: controls the growth process.
- Genetic system: contains a representation of the creature's genotype, allowing adaptation and evolution through mutation and crossover.

Even though the creature is quite dummy and the nervous system does nothing so far, this program was designed as a framework to experiment intelligent behaviours on simple creatures living in a simplified world.
