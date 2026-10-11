//! Carries the partition objects of generated functions to the final artifacts that import it. It declares
//! nothing: a compile links every object in its own module graph, so the objects stay off the `generated`
//! graph and an object compiled from hand-written code does not take them as inputs.
