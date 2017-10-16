
# Define basic building blocks for the package
# The main building block is the 'thing'
# A thing has other things...
# This lends a thing to be internally stored as a list
# (i.e mode(thing)) -> list

#' @export
create_thing<-function(things=NULL){

  t<-list(things)
  attr(t, "class")<-"thing"
  return (t)
}
