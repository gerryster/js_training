# Instead of using BackBone.LocalStorage directly from models or collections,
# require this module.  This allows unit tests to mock out this dependency.
define [], ()->
  Backbone.LocalStorage