package fubar;

@:enum abstract PlayMode(String) from String to String {
    var trending = "trending";
    var search = "search";
    var random = "random";
}
//enum PlayMode
