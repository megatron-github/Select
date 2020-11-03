"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
FILE: Select.st

NAME: Truong Pham

DATE: March 7th, 2020

DESCRIPTION: More than forty years ago, Edsger W. Dijkstra proposed a selection
construct for procedural languages, now known as Dijkstra’s guarded-if [2].
This construct consists of several blocks of code, each guarded by a boolean
condition. When the guarded-if is evaluated, all of the guard conditions are
evaluated. Then, from those that evaluate as true, one of the associated blocks
is selected arbitrarily and evaluated. (In the traditional presentation, it is
a run-time error if none of the guards is true.)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Object subclass: #Select.

Select extend [
  |condBlocks evalBlocks elseBlocks switchmsg setSwitch setElse setEnd setIfThen setCaseThen|
  init [
    condBlocks := OrderedCollection new.
    evalBlocks := OrderedCollection new.
    elseBlocks := OrderedCollection new.
    setSwitch := false.
    setElse := false.
    setEnd := false.
    setIfThen := false.
    setCaseThen := false.
  ]

  if: guardBlock then: thenBlock [
    setEnd ifTrue: [
      ^self error: 'No message should be sent after End'
    ].
    setSwitch ifTrue: [
      ^self error: 'No If:Then: message should follow Switch: message'
    ].
    setElse ifTrue: [
      ^self error: 'Else: message should be the last message before End'
    ].
    condBlocks add: guardBlock.
    evalBlocks add: thenBlock.
    self setIfThen_True.
  ]

  else: elseBlock [
    setEnd ifTrue: [
      ^self error: 'No message should be sent after End'
    ].
    setElse ifTrue: [
      ^self error: 'There should be only one Else: message'
    ].
    (setIfThen | setCaseThen) ifFalse: [
      ^self error: 'Need If:Then: or Case:Then: message before Else: message'
    ].
    elseBlocks add: elseBlock.
    self setElse_True.
  ]

  switch: item [
    setEnd ifTrue: [
      ^self error: 'No message should be sent after End'
    ].
    setSwitch ifTrue: [
      ^self error: 'Object can recieve only one Switch: message'
    ].
    setElse ifTrue: [
      ^self error: 'Else: message should be the last message before End'
    ].
    setIfThen ifTrue: [
      ^self error: 'Switch: should be the first message'
    ].
    switchmsg := item.
    self setSwitch_True.
  ]

  case: collectionBlock then: thenBlock [
    setEnd ifTrue: [
      ^self error: 'No message should be sent after End'
    ].
    setSwitch ifFalse: [
      ^self error: 'No Case:Then: message without Switch: message'
    ].
    setElse ifTrue: [
      ^self error: 'Else: message should be the last message before End'
    ].
    condBlocks add: collectionBlock.
    evalBlocks add: thenBlock.
    self setCaseThen_True.
  ]

  setCaseThen_True [setCaseThen := true]
  setIfThen_True [setIfThen := true]
  setSwitch_True [setSwitch := true]
  setElse_True [setElse := true]
  setEnd_True [setEnd := true]

  get_condBlocks [^condBlocks]
  get_evalBlocks [^evalBlocks]
  get_elseBlocks [^elseBlocks]
  get_switchmsg [^switchmsg]
  get_setEnd [^setEnd]
  get_setSwitch [^setSwitch]
]

Select subclass: AllSelect [
  "Evaluate the guards in order, from first to last. After each guard
   evaluation, when the guard is true, evaluate its associated block. If no
   guard is true, evaluate the block of the else cluase if it is present."

  init [super init]
  if: guardBlock then: thenBlock [super if: guardBlock then: thenBlock]
  else: elseBlock [super else: elseBlock]
  switch: item [super switch: item]
  case: collectBlock then: thenBlock [super case: collectBlock then: thenBlock]
  end [
    |condBlocks evalBlocks elseBlocks trueFound last|
    super get_setEnd ifTrue: [
      ^self error: 'No message should be sent after End'
    ].
    super setEnd_True.
    trueFound := 0.
    last := nil.
    condBlocks := super get_condBlocks.
    evalBlocks := super get_evalBlocks.
    elseBlocks := super get_elseBlocks.

    super get_setSwitch ifTrue: [
      1 to: (condBlocks size) do: [:i |
        ((condBlocks at: i) value includes: super get_switchmsg) ifTrue: [
          trueFound := trueFound + 1.
          last := (evalBlocks at: i) value.
        ]
      ]
    ]
    ifFalse: [
      1 to: (condBlocks size) do: [:i |
        (condBlocks at: i) value ifTrue: [
          trueFound := trueFound + 1.
          last := (evalBlocks at: i) value.
        ]
      ]
    ].
    (trueFound = 0) ifTrue: [
      (elseBlocks size > 0) ifTrue: [last := (elseBlocks at: 1) value]
    ].
    ^last.
  ]
]

Select subclass: AnySelect [
  "Evaluate all the guards. Evaluate any one of the blocks with a true guard.
   If no guard is true, evaluate the block of the else message if it is
   present."

  init [super init]
  if: guardBlock then: thenBlock [super if: guardBlock then: thenBlock]
  else: lastBlock [super else: lastBlock]
  switch: item [super switch: item]
  case: collectBlock then: thenBlock [super case: collectBlock then: thenBlock]
  end [
    |condBlocks evalBlocks anyBlocks trueFound last any|
    super get_setEnd ifTrue: [
      ^self error: 'No message should be sent after End'
    ].
    super setEnd_True.
    trueFound := 0.
    last := nil.
    any := 1.
    condBlocks := super get_condBlocks.
    evalBlocks := super get_evalBlocks.
    elseBlocks := super get_elseBlocks.

    super get_setSwitch ifTrue: [
      1 to: (condBlocks size) do: [:i |
        ((condBlocks at: i) value includes: super get_switchmsg) ifTrue: [
          trueFound := trueFound + 1.
          any := i.
        ]
      ]
    ]
    ifFalse: [
      1 to: (condBlocks size) do: [:i |
        (condBlocks at: i) value ifTrue: [
          trueFound := trueFound + 1.
          any := i.
        ]
      ]
    ].
    (trueFound > 0) ifTrue: [last := (evalBlocks at: any) value]
    ifFalse: [
      (elseBlocks size > 0) ifTrue: [last := (elseBlocks at: 1) value]
    ].
    ^last.
  ]
]

Select subclass: FirstSelect [
  "Evalue the gaurds in order, from first to last. Upon encountering the first
   true guard, evaluate its assoicated block and stop evaluating guards. If no
   guard is true, evaluate the block of the else cluase if it is present. Note
   that this is like the familiar if... else if... else semantics."

  init [super init]
  if: guardBlock then: thenBlock [super if: guardBlock then: thenBlock]
  else: lastBlock [super else: lastBlock]
  switch: item [super switch: item]
  case: collectBlock then: thenBlock [super case: collectBlock then: thenBlock]
  end [
    |condBlocks evalBlocks elseBlocks first last index|
    super get_setEnd ifTrue: [
      ^self error: 'No message should be sent after End'
    ].
    super setEnd_True.
    first := 0.
    last := nil.
    index := 1.
    condBlocks := super get_condBlocks.
    evalBlocks := super get_evalBlocks.
    elseBlocks := super get_elseBlocks.

    super get_setSwitch ifTrue: [
      [(condBlocks size >= index) & (first < 1)] whileTrue: [
        ((condBlocks at: index) value includes: super get_switchmsg) ifTrue: [
          last := (evalBlocks at: index) value.
          first := first + 1.
        ].
        index := index + 1.
      ]
    ]
    ifFalse: [
      [(condBlocks size >= index) & (first < 1)] whileTrue: [
        (condBlocks at: index) value ifTrue: [
          last := (evalBlocks at: index) value.
          first := first + 1.
        ].
        index := index + 1.
      ]
    ].
    (first = 0) ifTrue: [
      (elseBlocks size > 0) ifTrue: [last := (elseBlocks at: 1) value]
    ].
    ^last.
  ]
]

Select subclass: ExclusiveSelect [
  "Evaluate all the guards. If exactly one guard is true, evaluate its
   associated block. If no guard is true, evaluate the block of the else
   caluse, if it is present. If more than one guard is true, or if no guards
   is true and no else message is present, signal an error."

  init [super init]
  if: guardBlock then: thenBlock [super if: guardBlock then: thenBlock]
  else: lastBlock [super else: lastBlock]
  switch: item [super switch: item]
  case: collectBlock then: thenBlock [super case: collectBlock then: thenBlock]
  end [
    |condBlocks evalBlocks elseBlocks trueFound unique last|
    super get_setEnd ifTrue: [
      ^self error: 'No message should be sent after End'
    ].
    super setEnd_True.
    trueFound := 0.
    unique := 0.
    last := nil.
    condBlocks := super get_condBlocks.
    evalBlocks := super get_evalBlocks.
    elseBlocks := super get_elseBlocks.

    super get_setSwitch ifTrue: [
      1 to: (condBlocks size) do: [:i |
        ((condBlocks at: i) value includes: super get_switchmsg) ifTrue: [
          trueFound := trueFound + 1.
          unique := i.
        ]
      ]
    ]
    ifFalse: [
      1 to: (condBlocks size) do: [:i |
        (condBlocks at: i) value ifTrue: [
          trueFound := trueFound + 1.
          unique := i.
        ]
      ]
    ].
    (trueFound > 1) ifTrue: [
      ^self error: 'Select Exclusive should have exactly one true If: message'
    ].
    (trueFound = 1) ifTrue: [last := (evalBlocks at: unique) value].
    (trueFound = 0) ifTrue: [
      (elseBlocks size = 0) ifTrue: [
        ^self error: 'Else: message needed if all If: messages are false'
      ].
      (elseBlocks size > 0) ifTrue: [last := (elseBlocks at: 1) value].
    ].
    ^last.
  ]
]

Select class extend [
  all [ |r| r := AllSelect new. r init. ^r]
  any [ |r| r := AnySelect new. r init. ^r]
  first [ |r| r := FirstSelect new. r init. ^r]
  exclusive [ |r| r := ExclusiveSelect new. r init. ^r]
]
