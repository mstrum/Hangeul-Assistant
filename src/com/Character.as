package com
{
	public class Character
	{
		private static var jamoValues:Array = new Array('ㄱ','ㄲ','ㄳ','ㄴ','ㄵ','ㄶ','ㄷ','ㄸ','ㄹ','ㄺ','ㄻ','ㄼ','ㄽ','ㄾ','ㄿ','ㅀ','ㅁ','ㅂ','ㅃ','ㅄ','ㅅ','ㅆ','ㅇ','ㅈ','ㅉ','ㅊ','ㅋ','ㅌ','ㅍ','ㅎ','ㅏ','ㅐ','ㅑ','ㅒ','ㅓ','ㅔ','ㅕ','ㅖ','ㅗ','ㅘ','ㅙ','ㅚ','ㅛ','ㅜ','ㅝ','ㅞ','ㅟ','ㅠ','ㅡ','ㅢ','ㅣ');
		private static var choValues:Array = new Array('ㄱ','ㄲ','ㄴ','ㄷ','ㄸ','ㄹ','ㅁ','ㅂ','ㅃ','ㅅ','ㅆ','ㅇ','ㅈ','ㅉ','ㅊ','ㅋ','ㅌ','ㅍ','ㅎ');
		private static var jungValues:Array = new Array('ㅏ','ㅐ','ㅑ','ㅒ','ㅓ','ㅔ','ㅕ','ㅖ','ㅗ','ㅘ','ㅙ','ㅚ','ㅛ','ㅜ','ㅝ','ㅞ','ㅟ','ㅠ','ㅡ','ㅢ','ㅣ');
		private static var jongValues:Array = new Array('','ㄱ','ㄲ','ㄳ','ㄴ','ㄵ','ㄶ','ㄷ','ㄹ','ㄺ','ㄻ','ㄼ','ㄽ','ㄾ','ㄿ','ㅀ','ㅁ','ㅂ','ㅄ','ㅅ','ㅆ','ㅇ','ㅈ','ㅊ','ㅋ','ㅌ','ㅍ','ㅎ');
		
		private static function getIndexFrom(source:Array, letter:String):int {
	    	var i:int;
	    	for(i=0; i < source.length; i++) {
	    		if(source[i] == letter)
	    			return i;
	    	}
	    	return -1;
	    }
	    
	    public static function isVowel(jamo:String):Boolean
	    {
	    	return getIndexFrom(jungValues, jamo) != -1;
	    }
		
		public function Character(a:String = "", b:String = "", c:String = "")
		{
			cho = a;
			jung = b;
			jong = c;
		}
		
		public var cho:String = '';
		public var jung:String = '';
		public var jong:String = '';
		public var forceChar:String = '';
		
		public function ToString():String
    	{
    		if(forceChar != '')
    			return forceChar;
    		else if(jung == '' && jong == '')
    		{
    			if(cho == '')
    				return " ";
    			else
    				return String.fromCharCode(
	    					12593 +								// base
	    					getIndexFrom(jamoValues,cho));
    		}
    		else
    		{
	    		return String.fromCharCode(
	    					44032 +								// base
	    					getIndexFrom(choValues,cho)*588 +	// cho
	    					getIndexFrom(jungValues,jung)*28 +	// jung
	    					getIndexFrom(jongValues,jong));		// jong
	    	}
    	}
    	
    	public function IsSpace():Boolean
    	{
    		return cho == '' && jung == '' && jong == '' && forceChar == '';
    	}
    	
    	public function IsEmpty():Boolean
    	{
    		return IsSpace();
    	}
    	
    	public function IsOther():Boolean
    	{
    		return forceChar != '';
    	}
    	
    	public function Load(code:int):void
    	{
			var value:int;
    		// space
    		if(code == 32)
    		{
    			cho = '';
    			jong = '';
    			jung = '';
    		// full character
    		} else if( code > 44031 && code < 55204) {
    			value = code - 44032;
    		
		    	// get the bottom letter (if any)
		    	var divJong:int = value / 28;
		    	var modJong:int = value % 28;
		    	jong = jongValues[modJong];
		    	
		    	// get the middle letter
		    	var divJung:int = divJong / 21;
		    	var modJung:int = divJong % 21;
		    	jung = jungValues[modJung];
		    	
		    	// get the top letter
		    	var divCho:int = divJung / 19;
		    	var modCho:int = divJung % 19;
		    	cho = choValues[modCho];
    		// single jamo
    		} else if( code > 12592 && code < 12644) {
    			value = code - 12593;
    			cho = jamoValues[value];
    		}

    		// not korean
    		forceChar = String.fromCharCode(code);
    	}
    	
    	// returns true if nothing to delete
    	public function removeJamo():Boolean
    	{
    		if(jong != '')
    		{
    			switch(jong) {
    				case 'ㄳ':
    					jong = 'ㄱ';
    					return false;
    				case 'ㄵ':
    				case 'ㄶ':
    					jong = 'ㄴ';
    					return false;
    				case 'ㄺ':
    				case 'ㄻ':
    				case 'ㄼ':
    				case 'ㄽ':
    				case 'ㄾ':
    				case 'ㄿ':
    				case 'ㅀ':
    					jong = 'ㄹ';
    					return false;
    				case 'ㅄ':
    					jong = 'ㅂ';
    					return false;
    			}
    			jong = '';
    		}
    		else if(jung != '')
    		{
    			switch(jung) {
    				case 'ㅘ':
    				case 'ㅙ':
    				case 'ㅚ':
    					jung = 'ㅗ';
    					return false;
    				case 'ㅢ':
    					jung = 'ㅡ';
    					return false;
    				case 'ㅝ':
    				case 'ㅞ':
    				case 'ㅟ':
    					jung = 'ㅜ';
    					return false;
    			}
    			jung = '';
    		}
    		else if(cho != '')
    		{
    			switch(cho) {
    				case 'ㅘ':
    				case 'ㅙ':
    				case 'ㅚ':
    					cho = 'ㅗ';
    					return false;
    				case 'ㅢ':
    					cho = 'ㅡ';
    					return false;
    				case 'ㅝ':
    				case 'ㅞ':
    				case 'ㅟ':
    					cho = 'ㅜ';
    					return false;
    			}
    			cho = '';
    		}
    		else
    			return true;
    		return false;
    	}
    	
    	public function addJamo(jamo:String):Character
    	{
    		var newChar:Character = null;
    		// vowel
    		if(isVowel(jamo)) {
    			if(jong != '') {
    				newChar = new Character;
    				switch(jong) {
		    				case 'ㄳ':
		    					jong = 'ㄱ';
		    					newChar.cho = 'ㅅ';
		    					break;
		    				case 'ㄵ':
		    					jong = 'ㄴ';
		    					newChar.cho = 'ㅈ';
		    					break;
		    				case 'ㄶ':
		    					jong = 'ㄴ';
		    					newChar.cho = 'ㅎ';
		    					break;
		    				case 'ㄺ':
		    					jong = 'ㄹ';
		    					newChar.cho = 'ㄱ';
		    					break;
		    				case 'ㄻ':
		    					jong = 'ㄹ';
		    					newChar.cho = 'ㅡ';
		    					break;
		    				case 'ㄼ':
		    					jong = 'ㄹ';
		    					newChar.cho = 'ㅂ';
		    					break;
		    				case 'ㄽ':
		    					jong = 'ㄹ';
		    					newChar.cho = 'ㅅ';
		    					break;
		    				case 'ㄾ':
		    					jong = 'ㄹ';
		    					newChar.cho = 'ㅌ';
		    					break;
		    				case 'ㄿ':
		    					jong = 'ㄹ';
		    					newChar.cho = 'ㅍ';
		    					break;
		    				case 'ㅀ':
		    					jong = 'ㄹ';
		    					newChar.cho = 'ㅗ';
		    					break;
		    				case 'ㅄ':
		    					jong = 'ㅂ';
		    					newChar.cho = 'ㅅ';
		    					break;
		    			}
    				if(newChar.cho == '') {
	    				if(getIndexFrom(choValues, jong) != -1) {
	    					newChar.cho = jong;
	    					newChar.jung = jamo;
	    					jong = '';
	    				} else {
	    					newChar.cho = jamo;
	    				}
    				} else {
    					newChar.jung = jamo;
    				}
    					
    			} else if(jung != '') {
    				switch(jung) {
    					case 'ㅜ':
    						switch(jamo) {
    							case 'ㅓ':
    								jung = 'ㅝ';
    								return null;
    							case 'ㅔ':
    								jung = 'ㅞ';
    								return null;
    							case 'ㅣ':
    								jung = 'ㅟ';
    								return null;
    						}
    						break;
    					case 'ㅗ':
    						switch(jamo) {
    							case 'ㅏ':
    								jung = 'ㅘ';
    								return null;
    							case 'ㅣ':
    								jung = 'ㅚ';
    								return null;
    							case 'ㅐ':
    								jung = 'ㅙ';
    								return null;
    						}
    						break;
    					case 'ㅡ':
    						switch(jamo) {
    							case 'ㅣ':
    								jung = 'ㅢ';
    								return null;
    						}
    						break;    						
    				}
    				newChar = new Character;
    				newChar.cho = jamo;
    			} else if(cho != ''){
    				if(getIndexFrom(choValues, cho) != -1)
    					jung = jamo;
    				else {
    					switch(cho) {
	    					case 'ㅜ':
	    						switch(jamo) {
	    							case 'ㅓ':
	    								cho = 'ㅝ';
	    								return null;
	    							case 'ㅔ':
	    								cho = 'ㅞ';
	    								return null;
	    							case 'ㅣ':
	    								cho = 'ㅟ';
	    								return null;
	    						}
	    						break;
	    					case 'ㅗ':
	    						switch(jamo) {
	    							case 'ㅏ':
	    								cho = 'ㅘ';
	    								return null;
	    							case 'ㅣ':
	    								cho = 'ㅚ';
	    								return null;
	    							case 'ㅐ':
	    								cho = 'ㅙ';
	    								return null;
	    						}
	    						break;
	    					case 'ㅡ':
	    						switch(jamo) {
	    							case 'ㅣ':
	    								cho = 'ㅢ';
	    								return null;
	    						}
	    						break;    						
	    				}
    					newChar = new Character;
    					newChar.cho = jamo;
    				}
    			} else
    				cho = jamo;
    		// consonant
    		} else {
    			// check for starting consonant
    			if(cho == '')
    				cho = jamo;
    			// check for ending consonant
    			else {
    				var toEdit:String = '';
    				var check:String = '';
    				if(jung == '')
    					check = cho;
    				else
    					check = jong;
    				
    				switch(check) {
    					case 'ㄱ':
	    					switch(jamo) {
		    					case 'ㅅ':
		    						toEdit = 'ㄳ';
		    						break;
	    					}
    						break;
    					case 'ㄴ':
	    					switch(jamo) {
		    					case 'ㅈ':
		    						toEdit = 'ㄵ';
		    						break;
		    					case 'ㅎ':
		    						toEdit = 'ㄶ';
		    						break;
	    					}
    						break;
    					case 'ㄹ':
	    					switch(jamo) {
		    					case 'ㄱ':
		    						toEdit = 'ㄺ';
		    						break;
		    					case 'ㅁ':
		    						toEdit = 'ㄻ';
		    						break;
		    					case 'ㅂ':
		    						toEdit = 'ㄼ';
		    						break;
		    					case 'ㅅ':
		    						toEdit = 'ㄽ';
		    						break;
		    					case 'ㅌ':
		    						toEdit = 'ㄾ';
		    						break;
		    					case 'ㅍ':
		    						toEdit = 'ㄿ';
		    						break;
		    					case 'ㅎ':
		    						toEdit = 'ㅀ';
		    						break;
	    					}
    						break;
    					case 'ㅂ':
	    					switch(jamo) {
		    					case 'ㅅ':
		    						toEdit = 'ㅄ';
		    						break;
	    					}
    						break;
    					case '':
    						if(jongValues.lastIndexOf(jamo)>-1)
	    					{
	    						jong = jamo;
	    					} else {
	    						newChar = new Character;
    							newChar.cho = jamo;
	    					}
    						return newChar;
    				}
    				if(toEdit != '')
    				{
    					if(jung == '')
    						cho = toEdit;
	    				else
	    				{
	    					if(jongValues.lastIndexOf(toEdit)>-1)
	    					{
	    						jong = toEdit;
	    					} else {
	    						newChar = new Character;
    							newChar.cho = jamo;
	    					}   					
	    				}
    				}
    				else
    				{
    					newChar = new Character;
    					newChar.cho = jamo;
    				}
    			}
    		}
    		
    		// returns the resulting character(s)
    		return newChar;
    	}

	}
}