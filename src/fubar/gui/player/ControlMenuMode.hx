package fubar.gui.player;

import js.Browser.document;
import js.html.ImageElement;
import js.html.InputElement;

enum PlaySettingsChange {
    mode( m : PlayMode );
    search( t : String );
}

class ControlMenuMode extends ControlMenu {

    static inline var LETTER_WIDTH = 14;

    public dynamic function onChange( change : PlaySettingsChange ) {}

	public var searchTerm(get,null) : String;
	inline function get_searchTerm() return searchInput.value;

    var trendingButton : ImageElement;
    var searchButton : ImageElement;
    var searchInput : InputElement;
    var searchClear : ImageElement;

    public function new() {

        super( 'mode' );

        trendingButton = addIconButton( 'trending' );
        trendingButton.onclick = function(_) {
            setMode( search );
            onChange( mode( search ) );
        }

        searchButton = addIconButton( 'search' );
        searchButton.style.display = 'none';
        searchButton.onclick = function(_) {
            setMode( trending );
            onChange( mode( trending ) );
        }

        searchInput = document.createInputElement();
        searchInput.type = 'search';
        searchInput.addEventListener( 'input', handleSearchInput, false );
        searchInput.addEventListener( 'search', handleSearchEnter, false );
        element.appendChild( searchInput );

        searchClear = addIconButton( 'clear' );
		searchClear.addEventListener( 'click', handleClearClick, false );

    //    if( App.settings.search != null )
    //        setSearchText( App.settings.search );

        //setMode( App.settings.mode );
    }

	public override function dispose() {
		super.dispose();
		searchInput.removeEventListener( 'input', handleSearchInput );
        searchInput.removeEventListener( 'search', handleSearchEnter );
        searchClear.removeEventListener( 'click', handleClearClick );
	}

    function setMode( mode : PlayMode ) {
        switch mode {
        case trending:
            trendingButton.style.display = 'inline-block';
            searchButton.style.display = 'none';
            searchInput.style.display = 'none';
            //searchClear.style.display = 'none';

        case search:
            trendingButton.style.display = 'none';
            searchButton.style.display = 'inline-block';
            searchInput.style.display = 'inline-block';
            if( searchInput.value.length == 0 ) {
                searchClear.style.opacity = 'none';
                searchInput.focus();
            } else {
                searchClear.style.display = 'inline-block';
				//searchClear.style.opacity = '1';
            }
        }
    }

    function setSearchText( text : String ) {
        searchInput.value = text;
        updateSearchInput();
    }

    function updateSearchInput() {
        searchInput.style.width = Std.int( LETTER_WIDTH*1.2 + (LETTER_WIDTH * (searchInput.value.length)) ) +'px';
        if( searchInput.value.length == 0 ) {
            searchClear.style.display = 'none';
            searchInput.focus();
        } else {
            searchClear.style.display = 'inline-block';
        }
    }

    function handleSearchInput(e) {
        updateSearchInput();
    }

    function handleSearchEnter(e) {
        e.preventDefault();
        e.stopPropagation();
        searchInput.blur();
        onChange( search( searchInput.value ) );
    }

	function handleClearClick(e) {
		e.stopPropagation();
		e.preventDefault();
		setSearchText( '' );
		searchInput.focus();
	}
}
