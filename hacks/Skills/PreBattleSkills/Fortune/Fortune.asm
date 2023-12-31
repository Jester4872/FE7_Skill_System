.thumb

@called from 28D20
@r0=#0x8BDCEB4
@r1=#0x0000004
@r2=#0x0000018
@r3=#0x203A456	battle calculations struct? 
@r4=#0x203A3F0	attacker struct
@r5=#0x203A470 	defender struct
@r6=#0x00000FF
@r7=#0x202BD50	character struct
@r8=#0x000000B
@r9=#0x0000000
@r10=#0x0000000
@r11=#0x3007DFC
@r12=#0x203A470	defender struct
@r13=#0x3007D1C
@r14=#0x8028D20

mov		r1,r4
mov		r2,r5
ldrb 	r1, [r1, #0xB]		    @load deployment byte from attacker struct (player or enemy)
ldrb 	r2, [r2, #0xB]		    @load deployment byte from defender struct (player or enemy)
mov 	r3, #0x80			    @load enemy allegiance bit
and 	r1, r3				    @trim the trailing bits of the allegiance value
and 	r2, r3				    @trim the trailing bits of the allegiance value
cmp 	r1, #0x80			    @is the attacker an enemy?
beq 	CheckCharacterAtk		@apply Fortune to the enemy if true
cmp 	r2, #0x80			    @is the defender an enemy?
beq 	CheckCharacterDef		@apply Fortune to the enemy if true

CheckCharacterAtk:
    ldr     r1,[r4,#0x0]        @load the ROM address of the current character
    ldrb    r1,[r1,#0x4]        @load their character ID byte
    mov     r3,r1               @copy it into another register to prevent overwritting it
    ldr     r1,FortuneID        @load the ID value we have defined
    cmp     r3,r1               @compare the values of both registers
    beq     FortuneAttacker     @if the character ID is the same in both, branch to apply Fortune
    b       End                 @else we branch to the end

CheckCharacterDef:
    ldr     r1,[r5,#0x0]        @load the ROM address of the current character
    ldrb    r1,[r1,#0x4]        @load their character ID byte
    mov     r3,r1               @copy it into another register to prevent overwritting it
    ldr     r1,FortuneID        @load the ID value we have defined
    cmp     r3,r1               @compare the values of both registers
    beq     FortuneDefender     @if the character ID is the same in both, branch to apply Fortune
    b       End                 @else we branch to the end

FortuneAttacker: 
    mov 	r1,r4
    add 	r1,#0x66            @get the critical byte
    mov 	r3,#0               @get the value to set the byte to (0)
    strb 	r3,[r1]             @set the new critical value for the enemy
    b 		End

FortuneDefender:
    mov 	r2,r5
    add 	r2,#0x66            @get the critical byte
    mov 	r3,#0               @get the value to set the byte to (0)
    strb 	r3,[r2]             @set the new critical value for the enemy
    b 		End

End:
    ldr		r3,=#0x203A456
    ldr		r1,[r4,#0x4]		@load the pointer to the defender's class data
    ldr		r0,[r0,#0x28]
    ldr		r1,[r1,#0x28]
    orr		r0,r1
    mov		r1,#0x40
    and		r0,r1
    ldr		r6,=#0x8028D2C|1
    bx		r6

.ltorg
.align
FortuneID:                      @refer to the value defined in the event file
