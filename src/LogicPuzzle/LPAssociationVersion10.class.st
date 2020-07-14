"
I represent an association between two puzzle traits. 

I use my traits to create a pair of Dictionaries, representing Row and Column.
My Dictionary keys are taken from the set of tags for each of my traits. 

I form a grid, in row-major order, with each cell containing ( true | false | nil ). 
If a cell is ""true"", its row tag is logically associated with its column tag. 
If a cell is ""false"", its row tag is not associated with its column tag. 
If a cell is ""nil"", the associate between the two trait values is unknown. 

I know how to set an association in myself, and I can report the status of an association.
I know how to inspect myself to determine if I am logically complete (all traits are associated).
I know how to inspect myself to determine if I am logically consistent 
 (i.e., every row trait can be associated with only one column trait).

I know how to render myself as a printable string. 
I know how to render an entire row or column of myself as a printable string. 
"
Class {
	#name : #LPAssociationVersion10,
	#superclass : #Object,
	#instVars : [
		'isComplete',
		'isConsistent',
		'isModified',
		'firstTrait',
		'secondTrait',
		'name',
		'matrix',
		'matrixString',
		'matchCoords'
	],
	#classInstVars : [
		'nameSeparator'
	],
	#category : #'LogicPuzzle-Version10'
}

{ #category : #accessing }
LPAssociationVersion10 class >> nameSeparator [
	^ nameSeparator
]

{ #category : #accessing }
LPAssociationVersion10 class >> nameSeparator: aString [
	nameSeparator := aString
]

{ #category : #naming }
LPAssociationVersion10 class >> nameWith: firstSymbol with: secondSymbol [
	"Create an association name (symbol) from its trait names."

	^ (String
		streamContents: [ :stream | 
			stream
				nextPutAll: firstSymbol asString;
				nextPutAll: self nameSeparator;
				nextPutAll: secondSymbol asString ]) asSymbol
]

{ #category : #'instance creation' }
LPAssociationVersion10 class >> newWith: firstTrait with: secondTrait [
	"Create a new association between two given traits."

	^ self new
		isComplete: false;
		isConsistent: true;
		isModified: false;
		
		"Register the traits, which contain the grid indices:"
		firstTrait: firstTrait;
		secondTrait: secondTrait;
		
		"Use the trait names to make a unique association name:"
		name: (self nameWith: firstTrait name with: secondTrait name);
			
		"Create the matrix that will hold the linked associations:"
		matrix: (Array2D new: firstTrait tags size);
		matrixString: '';
		
		"There can be as many as N matched traits per association:"
		matchCoords: OrderedCollection new;
		yourself
]

{ #category : #naming }
LPAssociationVersion10 class >> traitNamesFrom: anAssociationName [
	"Decompose an association key into its constituent trait keys."
	
	^ anAssociationName splitOn: self nameSeparator 
]

{ #category : #accessing }
LPAssociationVersion10 >> firstTrait [
	^ firstTrait
]

{ #category : #accessing }
LPAssociationVersion10 >> firstTrait: aTrait [
	firstTrait := aTrait
]

{ #category : #'accessing matrices' }
LPAssociationVersion10 >> isColAllFalse: colIndex [
	"Scan a column in the association matrix for 1 nil & N-1 falses."

	| value nilFound |
	nilFound := false.
	
	1 to: matrix numberOfRows do: [ :rowIndex | 
		value := matrix at: rowIndex at: colIndex.
		value
			ifNil: [ nilFound
					ifFalse: [ nilFound := true ]
					ifTrue: [ ^ false ] ]
			ifNotNil: [ value
					ifTrue: [ ^ false ] ] ].
	^ true
]

{ #category : #accessing }
LPAssociationVersion10 >> isComplete [
	^ isComplete
]

{ #category : #accessing }
LPAssociationVersion10 >> isComplete: aBoolean [
	isComplete := aBoolean
]

{ #category : #accessing }
LPAssociationVersion10 >> isConsistent [
	^ isConsistent
]

{ #category : #accessing }
LPAssociationVersion10 >> isConsistent: aBoolean [
	isConsistent := aBoolean
]

{ #category : #accessing }
LPAssociationVersion10 >> isModified [
	^ isModified
]

{ #category : #accessing }
LPAssociationVersion10 >> isModified: aBoolean [
	isModified := aBoolean
]

{ #category : #'accessing matrices' }
LPAssociationVersion10 >> isRowAllFalse: rowIndex [
	"Scan a row in the association matrix for 1 nil & N-1 falses."

	| value nilFound |
	nilFound := false.
	
	1 to: matrix numberOfColumns do: [ :colIndex | 
		value := matrix at: rowIndex at: colIndex.
		value
			ifNil: [ nilFound
					ifFalse: [ nilFound := true ]
					ifTrue: [ ^ false ] ]
			ifNotNil: [ value
					ifTrue: [ ^ false ] ] ].
	^ true
]

{ #category : #accessing }
LPAssociationVersion10 >> matchCoords [
	^ matchCoords
]

{ #category : #accessing }
LPAssociationVersion10 >> matchCoords: anOrderedCollection [
	matchCoords := anOrderedCollection
]

{ #category : #accessing }
LPAssociationVersion10 >> matrix [
	^ matrix
]

{ #category : #accessing }
LPAssociationVersion10 >> matrix: anArray2D [
	matrix := anArray2D
]

{ #category : #accessing }
LPAssociationVersion10 >> matrixString [
	^ matrixString
]

{ #category : #accessing }
LPAssociationVersion10 >> matrixString: aString [
	matrixString := aString
]

{ #category : #accessing }
LPAssociationVersion10 >> name [
	^ name
]

{ #category : #accessing }
LPAssociationVersion10 >> name: stringOrSymbol [
	name := stringOrSymbol 
]

{ #category : #accessing }
LPAssociationVersion10 >> secondTrait [
	^ secondTrait
]

{ #category : #accessing }
LPAssociationVersion10 >> secondTrait: aTrait [
	secondTrait := aTrait
]

{ #category : #'accessing matrices' }
LPAssociationVersion10 >> setColFalse: colIndex [
	"Walk the indicated column in the matrix, setting nils to 'false'."

	| trueFound |
	trueFound := false.
	1 to: matrix numberOfRows do: [ :rowIndex | 
		(matrix at: rowIndex at: colIndex)
			ifNil: [ matrix at: rowIndex at: colIndex put: false. self isModified: true ]
			ifNotNil: [ (matrix at: rowIndex at: colIndex)
					ifTrue: [ trueFound
							ifFalse: [ trueFound := true ]
							ifTrue: [ self
									error: 'Inconsistency found in ' , self name , ': two trues in one column' ] ] ] ]
]

{ #category : #'accessing matrices' }
LPAssociationVersion10 >> setRowFalse: rowIndex [
	"Walk the indicated row in the matrix, setting nils to 'false'."

	| trueFound |
	trueFound := false.
	1 to: matrix numberOfColumns do: [ :colIndex | 
		(matrix at: rowIndex at: colIndex)
			ifNil: [ matrix at: rowIndex at: colIndex put: false. self isModified: true ]
			ifNotNil: [ (matrix at: rowIndex at: colIndex)
					ifTrue: [ trueFound
							ifFalse: [ trueFound := true ]
							ifTrue: [ self
									error: 'Inconsistency found in ' , self name , ': two trues in one row' ] ] ] ]
]

{ #category : #'accessing matrices' }
LPAssociationVersion10 >> traitNamed: aTraitName [
	"Retrieve the association trait of the given name."
	
	firstTrait name = aTraitName 
		ifFalse: [ secondTrait name = aTraitName
			ifFalse: [ ^ nil ].
			^ secondTrait ].
	
	^ firstTrait
]

{ #category : #'accessing matrices' }
LPAssociationVersion10 >> traitOppositeOf: aTraitName [
	"Retrieve the association trait not of the given name."
	
	firstTrait name = aTraitName 
		ifFalse: [ secondTrait name = aTraitName
			ifFalse: [ ^ nil ].
			^ firstTrait ].
	
	^ secondTrait
]