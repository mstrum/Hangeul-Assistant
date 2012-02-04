package com
{
	public class Verb extends Word
	{
		private static var rVerbs:Array = new Array("길다","놀다","들다","만들다","멀다","살다","알다","열다","울다","팔다","힘들다","말다");
		private static var bVerbs:Array = new Array("가볍다","고맙다","곱다","눕다","굽다","귀엽다","깁다","까다롭다","더럽다","덥다","돕다",
													"두렵다","맵다","무겁다","밉다","반갑다","부럽다","아깝다","아름답다","어둡다","어렵다",
													"줍다","즐겁다","춥다", "안타깝다", "가깝다");
		private static var dVerbs:Array = new Array("걷다","깨닫다","듣다","묻다");
		private static var sVerbs:Array = new Array("낫다","짓다");
		private static var copulaVerbs:Array = new Array("이다","아니다");
		private static var howVerbs:Array = new Array("그렇다","이렇다","어떻다");
		
		public var adjectiveFlag:Boolean = false;	// Remove forms not applicable

	    public var bFlag:Boolean = false;		// Eg. 아깝다
	    public var dFlag:Boolean = false;		// Eg. 듣다
	    public var rFlag:Boolean = false;		// Eg. 살다
	    public var copulaFlag:Boolean = false;	// Eg. 이다
	    public var sFlag:Boolean = false;		// Eg. 낫다
	    public var hFlag:Boolean = false;
	    public var addedGlue:Boolean = false;
	    
	    public var contract:Boolean = false;
	    
		public function Verb()
		{
			super();
		}
		
		public override function Load(verb:String):Boolean
		{
			if(super.Load(verb))
				return true;
			
			if(IsContainedIn(copulaVerbs))
				copulaFlag = true;
			else if(IsContainedIn(rVerbs))
				rFlag = true;
			else if(IsContainedIn(bVerbs) || (Characters.length > 1 && Characters[Characters.length-1].ToString() == "럽" && Characters[Characters.length-2].ToString() == "스"))
				bFlag = true;
			else if(IsContainedIn(dVerbs))
				dFlag = true;
			else if(IsContainedIn(sVerbs))
				sFlag = true;
			
			return false;
		}
		
		public function ClonedVerb():Verb
		{
			var newVerb:Verb = new Verb;
			
			var i:int;
			for(i=0;i<Characters.length;i++)
			{
				newVerb.Characters.push(new Character(Characters[i].cho, Characters[i].jung, Characters[i].jong));
			}
			
			newVerb.adjectiveFlag = adjectiveFlag;	// Remove forms not applicable

		    newVerb.bFlag = bFlag;
		    newVerb.dFlag = dFlag;
		    newVerb.rFlag = rFlag;
		    newVerb.copulaFlag = copulaFlag;
		    newVerb.sFlag = sFlag;
		    newVerb.hFlag = hFlag;
		    
		    newVerb.addedGlue = addedGlue;
		    
		    newVerb.contract = contract;

		    return newVerb;
		}
		
		public function Conjugate():void
		{
			var character:Character = Characters[Characters.length-1];
			if(character.cho == 'ㄹ' && character.jung == 'ㅡ' && character.jong == '') {
				var previousCharacter:Character;
				previousCharacter = Characters[Characters.length-2];
				previousCharacter.jong = 'ㄹ';
				switch(previousCharacter.jung) {
    				case 'ㅗ':
    				case 'ㅏ':
    					if(!addedGlue)
    						character.jung = 'ㅏ';
    					else
    						character.jung = 'ㅓ';
						break;
    				default:
    					character.jung = 'ㅓ';
    			}
			} else if(sFlag) {
				character.jong = '';
				sFlag = false;
			} else if(rFlag) {		
				character.jong = '';
				rFlag = false;
			} else if(dFlag) {
				character.jong = 'ㄹ';
				dFlag = false;
			} else if(bFlag) {  
				character.jong = '';  
				Characters.push(new Character('ㅇ','ㅜ',''));				
				bFlag = false;
			} else if(character.jong == 'ㅎ' && character.ToString() != "놓") {
				character.jong = '';  
				hFlag = true;
			}
		}	
		
		public function ClearFlags():void
		{
			sFlag = false;
			rFlag = false;
			dFlag = false;
			bFlag = false;
			hFlag = false;
		}
		
		public function AddGlue(useContractions:Boolean):void
		{
			if(useContractions && !contract)
				useContractions = false;

			if(!rFlag)
			{
				if(NeedsConjugation())
					Conjugate();
			}
			else
				ClearFlags();
				
			var newCharacter:Character = new Character;
			var character:Character = Characters[Characters.length-1];
			var previousCharacter:Character;
			if(Characters.length>1)
				previousCharacter = Characters[Characters.length-2];
			
			if(copulaFlag)
			{
				if(Characters.length>1)
				{
					if(previousCharacter.jong == '' && useContractions)
						character.jung = 'ㅕ';
					else
						Characters.push(new Character('ㅇ','ㅓ',''));
				}
				else
					Characters.push(new Character('ㅇ','ㅓ',''));
				copulaFlag = false;
			} else if(hFlag) {
				if(character.ToString() == "러") {
					character.jung = 'ㅐ';
				} else {
					newCharacter.cho = 'ㅇ';
					switch(character.jung) {
	    				case 'ㅗ':
	    				case 'ㅏ':
	    					if(!addedGlue)
	    						newCharacter.jung = 'ㅏ';
	    					else
	    						newCharacter.jung = 'ㅓ';
							break;
	    				default:
	    					newCharacter.jung = 'ㅓ';
	    			}
		    		Characters.push(newCharacter);
				}
			} else if(character.jong == ''){
    			if(character.jung == 'ㅣ') {
    				character.jung = 'ㅕ';
    			} else if(character.cho == 'ㅎ' && character.jung == 'ㅏ') {
    				character.jung = 'ㅐ';
    			} else if(character.jung == 'ㅜ') {
    				if(previousCharacter != null && previousCharacter.ToString() == "도") {
    					if(useContractions)
	    					character.jung = 'ㅘ';
	    				else
	    					Characters.push(new Character('ㅇ','ㅏ',''));
    				} else {
	    				if(useContractions)
	    					character.jung = 'ㅝ';
	    				else
	    					Characters.push(new Character('ㅇ','ㅓ',''));
    				}
    			} else if(character.jung == 'ㅗ') {
    				if(useContractions)
    					character.jung = 'ㅘ';
    				else
    					Characters.push(new Character('ㅇ','ㅏ',''));
    			} else if(character.jung == 'ㅚ') {
    				if(useContractions)
    					character.jung = 'ㅙ';
    				else
    					Characters.push(new Character('ㅇ','ㅓ',''));
    			} else if(character.jung == 'ㅡ') {
    				if(Characters.length > 1) {
    					switch(previousCharacter.jung) {
		    				case 'ㅗ':
		    				case 'ㅏ':
		    					if(!addedGlue)
		    						character.jung = 'ㅏ';
		    					else
		    						character.jung = 'ㅓ';
    							break;
		    				default:
		    					character.jung = 'ㅓ';
		    			}
    				}
    				else
    					character.jung = 'ㅓ';
    			}
			} else {		
    			newCharacter.cho = 'ㅇ';
    			newCharacter.jong = '';
    			switch(character.jung) {
    				case 'ㅗ':
    				case 'ㅏ':
    					if(!addedGlue)
    						newCharacter.jung = 'ㅏ';
    					else
    						newCharacter.jung = 'ㅓ';
    					break;
    				default:
    					newCharacter.jung = 'ㅓ';
    			}
    			Characters.push(newCharacter);
			}
			addedGlue = true;
		}	

		public function ToNotApplicable():void
    	{
    		Characters = new Array;
			Characters.push(new Character('ㅇ','ㅓ','ㅄ'));
			Characters.push(new Character('ㅇ','ㅡ','ㅁ'));
    	}
    	
    	public function NeedsConjugation():Boolean
    	{
    		var character:Character = Characters[Characters.length-1];
    		return bFlag || dFlag || rFlag || sFlag
    				|| (character.cho == 'ㄹ' && character.jung == 'ㅡ' && character.jong == '')
    				|| character.jong == 'ㅎ';
    	}
    	
    	public function AddYo():void
		{
			Characters.push(new Character('ㅇ','ㅛ',''));
		}
		
		public function AddDa():void
		{
			Characters.push(new Character('ㄷ','ㅏ',''));
		}
		
		public function AddFormalStatementEnding():void
		{
			var character:Character = Characters[Characters.length-1];
			if(character.jong == '')
				character.jong = 'ㅂ';
			else
				Characters.push(new Character('ㅅ','ㅡ','ㅂ'));
			Characters.push(new Character('ㄴ','ㅣ',''));
			Characters.push(new Character('ㄷ','ㅏ',''));
		}
		
		public function AddFormalQuestionEnding():void
		{
			var character:Character = Characters[Characters.length-1];
			if(character.jong == '')
				character.jong = 'ㅂ';
			else
				Characters.push(new Character('ㅅ','ㅡ','ㅂ'));
			Characters.push(new Character('ㄴ','ㅣ',''));
			Characters.push(new Character('ㄲ','ㅏ',''));
		}

    	public function AddPoliteEnding():void
		{
			if(copulaFlag) {
				//Check to see if 이 should be removed
				Characters.push(new Character('ㅇ','ㅔ',''));
				copulaFlag = false;
			}
			else
				AddGlue(true);
			AddYo();
		}
    	
    	public function AddIntimateEnding():void
		{
			if(copulaFlag) {
				//Check to see if 이 should be removed
				Characters.push(new Character('ㅇ','ㅑ',''));
				copulaFlag = false;
			}
			else
				AddGlue(true);
		}
		
		public function AddFutureDescriptive():void
		{
			if(NeedsConjugation())
				Conjugate();
				
			var character:Character = Characters[Characters.length-1];
			if(character.jong != '')
				Characters.push(new Character('ㅇ','ㅡ','ㄹ'));
			else
				character.jong = 'ㄹ';
		}
    		
		public function AddHonorific():void
		{
			if(NeedsConjugation())
				Conjugate();
			
			var character:Character = Characters[Characters.length-1];
			if(character.jong != '')
				Characters.push(new Character('ㅇ','ㅡ',''));
			Characters.push(new Character('ㅅ','ㅣ',''));
		}    		

		public function AddPast():void
		{
			AddGlue(true);
			var character:Character = Characters[Characters.length-1];
			character.jong = 'ㅆ';
		}
		
		public function AddPastPerfect():void
		{
			AddPast();
			AddPast();
		}
		
		public function AddFutureShort():void
		{
			Characters.push(new Character('ㄱ','ㅔ','ㅆ'));
		}
    	
    	public function AddFutureLong():void
		{
			if(NeedsConjugation())
				Conjugate();

			AddFutureDescriptive();
			Characters.push(new Character('','',''));
			Characters.push(new Character('ㄱ','ㅓ','ㅅ'));
			Characters.push(new Character('ㅇ','ㅣ',''));
			copulaFlag = true;
		}

		public function AddFavorHigh():void
		{
			AddGlue(true);
			Characters.push(new Character('ㅈ','ㅜ',''));
		}
		
		public function AddFavorLow():void
		{
			AddGlue(true);
			Characters.push(new Character('ㄷ','ㅡ',''));
			Characters.push(new Character('ㄹ','ㅣ',''));
		}
		
		public function addTry():void
		{
			AddGlue(true);
			Characters.push(new Character('ㅂ','ㅗ',''));
		}
		
		public function addBecome():void
		{
			AddGlue(true);
			Characters.push(new Character('ㅈ','ㅣ',''));
		}
		
		public function AddPleasePoliteEnding():void
		{
			if(NeedsConjugation())
				Conjugate();
				
			var character:Character = Characters[Characters.length-1];
			if(character.jong != '')
				Characters.push(new Character('ㅇ','ㅡ',''));
			Characters.push(new Character('ㅅ','ㅔ',''));
			AddYo();
		}
		
		public function AddPleaseFormalEnding():void
		{
			if(NeedsConjugation())
				Conjugate();
				
			var character:Character = Characters[Characters.length-1];
			if(character.jong != '')
				Characters.push(new Character('ㅇ','ㅡ',''));
			Characters.push(new Character('ㅅ','ㅣ','ㅂ'));
			Characters.push(new Character('ㅅ','ㅣ',''));
			Characters.push(new Character('ㅇ','ㅗ',''));
		}
	
		public function AddLetsPoliteEnding():void
		{
			Characters.push(new Character('ㅈ','ㅏ',''));
		}
    		
		public function AddLetsFormalEnding():void
		{
			if(rFlag)
				Conjugate();
				
			var character:Character = Characters[Characters.length-1];
			if(character.jong == '')
				character.jong = 'ㅂ';
			else
				Characters.push(new Character('ㅇ','ㅡ','ㅂ'));
			Characters.push(new Character('ㅅ','ㅣ',''));
			Characters.push(new Character('ㄷ','ㅏ',''));
		}
    		
		public function AddRightIntimateEnding():void
		{
			Characters.push(new Character('ㅈ','ㅣ',''));
		}
		
		public function AddRightPoliteEnding():void
		{
			Characters.push(new Character('ㅈ','ㅛ',''));
		}
    		
		public function AddFyiIntimateEnding():void
		{
			Characters.push(new Character('ㄱ','ㅓ',''));
			Characters.push(new Character('ㄷ','ㅡ','ㄴ'));
		}
		
		public function AddFyiPoliteEnding():void
		{
			AddFyiIntimateEnding();
			AddYo();
		}
		
		public function addSince():void
		{
			if(NeedsConjugation())
				Conjugate();
				
			var character:Character = Characters[Characters.length-1];
			if(character.jong != '')
				Characters.push(new Character('ㅇ','ㅡ',''));
			Characters.push(new Character('ㄴ','ㅣ',''));
			Characters.push(new Character('ㄲ','ㅏ',''));
		}
		
		public function addIf():void
		{
			if(!rFlag)
			{
				if(NeedsConjugation())
					Conjugate();
			}
			else
				ClearFlags();
				
			var character:Character = Characters[Characters.length-1];
			if(character.jong != '')
				Characters.push(new Character('ㅇ','ㅡ',''));
			Characters.push(new Character('ㅁ','ㅕ','ㄴ'));
		}
		
		public function AddAnd():void
		{
			Characters.push(new Character('ㄱ','ㅗ',''));
		}

		public function AddInOrderToLong():void
		{
			Characters.push(new Character('ㄱ','ㅣ',''));
			Characters.push(new Character('','',''));
			Characters.push(new Character('ㅇ','ㅟ',''));
			Characters.push(new Character('ㅎ','ㅐ',''));
			Characters.push(new Character('ㅅ','ㅓ',''));
		}
		
		public function AddInOrderToShort():void
		{
			Characters.push(new Character('ㄷ','ㅗ',''));
			Characters.push(new Character('ㄹ','ㅗ','ㄱ'));
		}
		
		public function AddHaveTo():void
		{
			AddGlue(true);
			Characters.push(new Character('ㅇ','ㅑ',''));
			Characters.push(new Character('','',''));
			Characters.push(new Character('ㄷ','ㅚ',''));
		}
		
		public function AddDontAfter():void
		{
			Characters.push(new Character('ㅈ','ㅣ',''));
			Characters.push(new Character('','',''));
			Characters.push(new Character('ㅇ','ㅏ','ㄶ'));
		}
		
		public function AddDontCommand():void
		{
			Characters.push(new Character('ㅈ','ㅣ',''));
			Characters.push(new Character('','',''));
			Characters.push(new Character('ㅁ','ㅏ','ㄹ'));
			rFlag = true;
		}
		
		public function AddCantUnableAfter():void
		{
			Characters.push(new Character('ㅈ','ㅣ',''));
			Characters.push(new Character('','',''));
			Characters.push(new Character('ㅁ','ㅗ','ㅅ'));
			Characters.push(new Character('ㅎ','ㅏ',''));
		}
		
		public function AddCantPhysically():void
		{
			AddFutureDescriptive();
			Characters.push(new Character('','',''));
			Characters.push(new Character('ㅅ','ㅜ',''));
			Characters.push(new Character('','',''));
			Characters.push(new Character('ㅇ','ㅓ','ㅄ'));
		}
		
		public function AddCan():void
		{
			AddFutureDescriptive();
			Characters.push(new Character('','',''));
			Characters.push(new Character('ㅅ','ㅜ',''));
			Characters.push(new Character('','',''));
			Characters.push(new Character('ㅇ','ㅣ','ㅆ'));
		}
		
		public function AddProgressivePresent():void
		{
			Characters.push(new Character('ㄱ','ㅗ',''));
			Characters.push(new Character('','',''));
			Characters.push(new Character('ㅇ','ㅣ','ㅆ'));
		}
		
		public function AddProgressiveState():void
		{
			AddGlue(true);
			Characters.push(new Character('','',''));
			Characters.push(new Character('ㅇ','ㅣ','ㅆ'));
		}
		
		public function AddWantIntimate():void
		{
			AddFutureDescriptive();
			Characters.push(new Character('ㄹ','ㅐ',''));
		}
		
		public function AddWantPolite():void
		{
			AddWantIntimate();
			AddYo();
		}
		
		public function AddWant():void
		{
			Characters.push(new Character('ㄱ','ㅗ',''));
			Characters.push(new Character('','',''));
			Characters.push(new Character('ㅅ','ㅣ','ㅍ'));
		}
		
		public function AddIntent():void
		{
			var character:Character = Characters[Characters.length-1];
			if(character.jong != '')
				Characters.push(new Character('ㅇ','ㅡ',''));
			Characters.push(new Character('ㄹ','ㅕ',''));
			Characters.push(new Character('ㄱ','ㅗ',''));
			Characters.push(new Character('','',''));
			Characters.push(new Character('ㅎ','ㅏ',''));
		}
		
		public function AddBut():void
		{
			Characters.push(new Character('ㅈ','ㅣ',''));
			Characters.push(new Character('ㅁ','ㅏ','ㄴ'));
		}
		
		public function AddEvenThough():void
		{
			AddGlue(true);
			Characters.push(new Character('ㄷ','ㅗ',''));
		}
		
		public function AddOr():void
		{
			Characters.push(new Character('ㄱ','ㅓ',''));
			Characters.push(new Character('ㄴ','ㅏ',''));
		}
		
		public function AddWhile():void
		{
			if(NeedsConjugation())
				Conjugate();
			
			var character:Character = Characters[Characters.length-1];
			if(character.jong != '')
				Characters.push(new Character('ㅇ','ㅡ',''));
			Characters.push(new Character('ㅁ','ㅕ','ㄴ'));
			Characters.push(new Character('ㅅ','ㅓ',''));
		}
		
		public function AddWhen():void
		{
			AddFutureDescriptive();
			Characters.push(new Character('','',''));
			Characters.push(new Character('ㄸ','ㅐ',''));
		}
	}
}