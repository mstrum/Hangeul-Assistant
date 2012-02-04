package com
{
	import mx.controls.LinkButton;
	
	public class Word
	{		
		public var Characters:Array = new Array;
		public var OriginalWord:String = "";
		public var IsVerb:Boolean = false;
		public var IsSentence:Boolean = false;
		
		public function Word()
		{
		}
		
		public function ClonedWord():Word
		{
			var newWord:Word = new Word;
			newWord.OriginalWord = OriginalWord;
			var i:int;
			for(i=0;i<Characters.length;i++)
				newWord.Characters.push(new Character(Characters[i].cho, Characters[i].jung, Characters[i].jong));
			return newWord;
		}
		
		public function ToString():String
		{
			var newWord:String = "";
		    
		    for each (var char:Character in Characters)
		    	newWord += char.ToString();
		    
		    return newWord;
		}
		
		public function ToClickableString():LinkButton
		{
			var t:LinkButton = new LinkButton;
			t.name = ToString();
			return t;
		}
		
		public function Load(word:String):Boolean
		{
			if(word.length==0)
				return true;
				
			OriginalWord = word;
			var i:int;
			for(i=0;i<word.length;i++)
			{
				var processed:Character = new Character;
				if(processed.Load(word.charCodeAt(i)))
					return true;
				if(processed.IsSpace())
					IsSentence = true;
				Characters.push(processed);
			}
			
			if(!IsSentence)
			{
				var lastChar:Character = Characters[Characters.length-1];
				if(lastChar.cho == 'ㄷ' && lastChar.jung == 'ㅏ' && lastChar.jong == '')
				{
					Characters.pop();
					IsVerb = true;
				}
			}
			
			return false;
		}
		
		public function ClearArray():void
		{
			Characters = new Array;
		}
		
		public function DetectSoundChanges():String
		{
			var pronounceWord:Word = ClonedWord();
			var changed:Boolean = false;
			var i:int;
			var currentChar:Character;
			var nextChar:Character;
			
			for(i=0;i<pronounceWord.Characters.length;i++)
			{
				currentChar = pronounceWord.Characters[i];
				if(i<pronounceWord.Characters.length-1)
					nextChar = pronounceWord.Characters[i+1];
				else
					nextChar = null;
				
				//----------------------------------------
				// start
				
				//----------------------------------------
				// bottom + top
				if(nextChar != null)
				{
					//ㅎ
					if(currentChar.jong == "ㅎ")
					{
						switch(nextChar.cho)
						{
							case "ㄱ":
								currentChar.jong = "ㄱ";
								nextChar.cho = "ㅋ";
								changed = true;
								break;
							case "ㄷ":
								currentChar.jong = "ㄷ";
								nextChar.cho = "ㅌ";
								changed = true;
								break;
							case "ㄴ":
								currentChar.jong = "ㄴ";
								nextChar.cho = "ㄴ";
								changed = true;
								break;
							case "ㅂ":
								currentChar.jong = "ㅂ";
								nextChar.cho = "ㅍ";
								changed = true;
								break;
							case "ㅅ":
								currentChar.jong = "ㅅ";
								nextChar.cho = "ㅆ";
								changed = true;
								break;
							case "ㅈ":
								currentChar.jong = "ㄷ";
								nextChar.cho = "ㅊ";
								changed = true;
								break;
							default:
						}
					}
					//Velar
					else if(isVelar(currentChar.jong))
					{
						switch(nextChar.cho)
						{
							case "ㄱ":
							case "ㄲ":
								currentChar.jong = "ㄱ";
								nextChar.cho = "ㄲ";
								changed = true;
								break;
							case "ㄷ":
							case "ㄸ":
								currentChar.jong = "ㄱ";
								nextChar.cho = "ㄸ";
								changed = true;
								break;
							case "ㄴ":
							case "ㄹ":
								currentChar.jong = "ㅇ";
								nextChar.cho = "ㄴ";
								changed = true;
								break;
							case "ㅁ":
								currentChar.jong = "ㅇ";
								nextChar.cho = "ㅁ";
								changed = true;
								break;
							case "ㅂ":
							case "ㅃ":
								currentChar.jong = "ㄱ";
								nextChar.cho = "ㅃ";
								changed = true;
								break;
							case "ㅅ":
							case "ㅆ":
								currentChar.jong = "ㄱ";
								nextChar.cho = "ㅆ";
								changed = true;
								break;
							case "ㅈ":
							case "ㅉ":
								currentChar.jong = "ㄱ";
								nextChar.cho = "ㅉ";
								changed = true;
								break;
							case "ㅊ":
							case "ㅋ":
							case "ㅌ":
							case "ㅍ":
								currentChar.jong = "ㄱ";
								changed = true;
								break;
							case "ㅎ":
								currentChar.jong = '';
								nextChar.cho = "ㅋ";
								changed = true;
								break;
							default:
						}
					}
					//ㅇ
					else if(currentChar.jong == "ㅇ")
					{
						switch(nextChar.cho)
						{
							case "ㄹ":
								nextChar.cho = "ㄴ";
								changed = true;
								break;
							default:
						}
					}
					//Coronal
					else if(isCoronal(currentChar.jong))
					{
						switch(nextChar.cho)
						{
							case "ㄱ":
							case "ㄲ":
								currentChar.jong = "ㄷ";
								nextChar.cho = "ㄲ";
								changed = true;
								break;
							case "ㄷ":
							case "ㄸ":
								currentChar.jong = "ㄷ";
								nextChar.cho = "ㄸ";
								changed = true;
								break;
							case "ㄴ":
							case "ㄹ":
								currentChar.jong = "ㄴ";
								nextChar.cho = "ㄴ";
								changed = true;
								break;
							case "ㅁ":
								currentChar.jong = "ㄴ";
								changed = true;
								break;
							case "ㅂ":
							case "ㅃ":
								currentChar.jong = "ㄷ";
								nextChar.cho = "ㅃ";
								changed = true;
								break;
							case "ㅅ":
							case "ㅆ":
								currentChar.jong = "ㅅ";
								nextChar.cho = "ㅆ";
								changed = true;
								break;
							case "ㅈ":
							case "ㅉ":
								currentChar.jong = "ㄷ";
								nextChar.cho = "ㅉ";
								changed = true;
								break;
							case "ㅊ":
							case "ㅋ":
							case "ㅌ":
							case "ㅍ":
								currentChar.jong = "ㄷ";
								changed = true;
								break;
							case "ㅎ":
								currentChar.jong = "";
								nextChar.cho = "ㅌ";
								changed = true;
							default:
						}
					}
					//ㄴ
					else if(currentChar.jong == "ㄴ")
					{
						switch(nextChar.cho)
						{
							case "ㄹ":
								currentChar.jong = "ㄹ";
								changed = true;
								break;
							default:
						}
					}
					//ㄹ
					else if(currentChar.jong == "ㄹ")
					{
						switch(nextChar.cho)
						{
							case "ㄴ":
								nextChar.cho = "ㄹ";
								changed = true;
								break;
							default:
						}
					}
					//labial
					else if(isLabial(currentChar.jong))
					{
						switch(nextChar.cho)
						{
							case "ㄱ":
							case "ㄲ":
								currentChar.jong = "ㅂ";
								nextChar.cho = "ㄲ";
								changed = true;
								break;
							case "ㄷ":
							case "ㄸ":
								currentChar.jong = "ㅂ";
								nextChar.cho = "ㄸ";
								changed = true;
								break;
							case "ㄴ":
							case "ㄹ":
								currentChar.jong = "ㅁ";
								nextChar.cho = "ㄴ";
								changed = true;
								break;
							case "ㅁ":
								currentChar.jong = "ㅁ";
								changed = true;
								break;
							case "ㅂ":
							case "ㅃ":
								currentChar.jong = "ㅂ";
								nextChar.cho = "ㅃ";
								changed = true;
								break;
							case "ㅅ":
							case "ㅆ":
								currentChar.jong = "ㅂ";
								nextChar.cho = "ㅆ";
								changed = true;
								break;
							case "ㅈ":
							case "ㅉ":
								currentChar.jong = "ㅂ";
								nextChar.cho = "ㅉ";
								changed = true;
								break;
							case "ㅊ":
							case "ㅋ":
							case "ㅌ":
							case "ㅍ":
								currentChar.jong = "ㅂ";
								changed = true;
								break;
							case "ㅎ":
								currentChar.jong = "";
								nextChar.cho = "ㅍ";
								changed = true;
							default:
						}
					}
					//ㅁ
					else if(currentChar.jong == "ㅁ")
					{
						switch(nextChar.cho)
						{
							case "ㄹ":
								nextChar.cho = "ㄴ";
								changed = true;
								break;
							default:
						}
					}

					// ㅇ Assimilation
					if(nextChar.cho == 'ㅇ' && currentChar.jong != '')
					{
						switch(currentChar.jong)
						{
							case "ㄳ":
								currentChar.jong = 'ㄱ';
								nextChar.cho = 'ㅅ';
								break;
							case "ㄺ":
								currentChar.jong = 'ㄹ';
								nextChar.cho = 'ㄱ';
								break;
							case "ㄵ":
								currentChar.jong = 'ㄴ';
								nextChar.cho = 'ㅈ';
								break;
							case "ㄶ":
								currentChar.jong = 'ㄴ';
								nextChar.cho = 'ㅎ';
								break;
							case "ㄽ":
								currentChar.jong = 'ㄹ';
								nextChar.cho = 'ㅅ';
								break;
							case "ㄾ":
								currentChar.jong = 'ㄹ';
								nextChar.cho = 'ㅌ';
								break;
							case "ㅀ":
								currentChar.jong = 'ㄹ';
								nextChar.cho = 'ㅎ';
								break;
							case "ㅄ":
								currentChar.jong = 'ㅂ';
								nextChar.cho = 'ㅅ';
								break;
							case "ㄼ":
								currentChar.jong = 'ㄹ';
								nextChar.cho = 'ㅂ';
								break;
							case "ㄿ":
								currentChar.jong = 'ㄹ';
								nextChar.cho = 'ㅍ';
								break;
							case "ㄻ":
								currentChar.jong = 'ㄹ';
								nextChar.cho = 'ㅁ';
								break;
							default:
								nextChar.cho = currentChar.jong;
								currentChar.jong = '';
							changed = true;
						}
					// Double consonant
					} else {
						switch(currentChar.jong)
						{
							case "ㄳ":
								currentChar.jong = 'ㄱ';
								changed = true;
								break;
							case "ㄺ":
								currentChar.jong = 'ㄱ';
								switch(nextChar.cho)
								{
									case "ㄱ":
										nextChar.cho = 'ㄲ';
										break;
									default:
								}
								changed = true;
								break;
							case "ㄵ":
								currentChar.jong = 'ㄴ';
								changed = true;
								break;
							case "ㄶ":
								currentChar.jong = 'ㄴ';
								switch(nextChar.cho)
								{
									case "ㄷ":
										nextChar.cho = 'ㅌ';
										break;
									case "ㅈ":
										nextChar.cho = 'ㅊ';
										break;
									case "ㄱ":
										nextChar.cho = 'ㅋ';
										break;
									case "ㅂ":
										nextChar.cho = 'ㅍ';
										break;
									default:
								}
								changed = true;
								break;
							case "ㄽ":
								currentChar.jong = 'ㄹ';
								changed = true;
								break;
							case "ㄾ":
								currentChar.jong = 'ㄹ';
								changed = true;
								break;
							case "ㅀ":
								currentChar.jong = 'ㄹ';
								switch(nextChar.cho)
								{
									case "ㄷ":
										nextChar.cho = 'ㅌ';
										break;
									case "ㅈ":
										nextChar.cho = 'ㅊ';
										break;
									case "ㄱ":
										nextChar.cho = 'ㅋ';
										break;
									case "ㅂ":
										nextChar.cho = 'ㅍ';
										break;
									default:
								}
								changed = true;
								break;
							case "ㅄ":
								currentChar.jong = 'ㅂ';
								changed = true;
								break;
							case "ㄼ":
								currentChar.jong = 'ㅂ';
								changed = true;
								break;
							case "ㄿ":
								currentChar.jong = 'ㅂ';
								changed = true;
								break;
							case "ㄻ":
								currentChar.jong = 'ㅁ';
								changed = true;
								break;
							default:
						}
					}
				}
				
				//----------------------------------------
				// end
				if(nextChar == null || nextChar.IsSpace())
				{
					if(isCoronal(currentChar.jong))
					{
						currentChar.jong = 'ㄷ';
						changed = true;
					} else if(isVelar(currentChar.jong))
					{
						currentChar.jong = 'ㄱ';
						changed = true;
					} else if(isLabial(currentChar.jong))
					{
						currentChar.jong = 'ㅂ';
						changed = true;
					} else {
						switch(currentChar.jong)
						{
							case "ㄳ":
							case "ㄺ":
								currentChar.jong = 'ㄱ';
								changed = true;
								break;
							case "ㄵ":
							case "ㄶ":
								currentChar.jong = 'ㄴ';
								changed = true;
								break;
							case "ㄽ":
							case "ㄾ":
							case "ㅀ":
								currentChar.jong = 'ㄹ';
								changed = true;
								break;
							case "ㅄ":
							case "ㄼ":
							case "ㄿ":
								currentChar.jong = 'ㅂ';
								changed = true;
								break;
							case "ㄻ":
								currentChar.jong = 'ㅁ';
								changed = true;
								break;
							default:
						}
					}
				}
			}
		    
		    if(changed)
				return pronounceWord.ToString();
			else
				return "[No change]";
		}
		
		public function isVelar(letter:String):Boolean
		{
			switch(letter)
			{
				case "ᆨ":
				case "ᄁ":
				case "ᆿ":
					return true;
				default:
					return false;
			}
		}
		
		public function isCoronal(letter:String):Boolean
		{
			switch(letter)
			{
				case "ㄷ":
				case "ㅌ":
				case "ㅅ":
				case "ㅆ":
				case "ㅈ":
				case "ㅊ":
					return true;
				default:
					return false;
			}
		}
		
		public function isLabial(letter:String):Boolean
		{
			switch(letter)
			{
				case "ㅂ":
				case "ㅍ":
					return true;
				default:
					return false;
			}
		}

		public function IsContainedIn(source:Array):Boolean
		{
			for each(var word:String in source)
			{
				if(word == OriginalWord)
					return true;
			}
			return false;
		}
	}
}