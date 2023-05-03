.include "../source/p1271_macros.s"
.globl p1271_nrBRW_computation
p1271_nrBRW_computation:

/*Parameters passed to p1305_nrBRW_computation by caller: rdi=no of bits, rsi=points to input message, rdx= points to input key, rcx=points to output*/


subq $300, %rsp

movq %rbx, 16(%rsp)
movq %r12, 24(%rsp)
movq %r13, 32(%rsp)
movq %r14, 40(%rsp)
movq %r15, 48(%rsp)
movq %rbp, 56(%rsp)
movq %rdx, 72(%rsp)
movq %rcx, 104(%rsp)



/*compute no_of_16-byte-blocks*/
xorq %rdx, %rdx
movq %rdi, %rax
movq %rax, 112(%rsp)

/*** load the effective address of the memory where the squares have been stored ***/
leaq squares, %rdi
movq %rdi, 64(%rsp)
/**********************************************************************************/


movq $0, 160(%rsp)
movq $0, 168(%rsp)


movq $120, %r12
divq %r12 /* divq requires dividend to be in rdx:rax..returns quotient in rax and remainder in rdx */

/*increase no_of_blocks by 1 if there is imperfect last block*/
cmp $0, %rdx
je no_imperfect_block
inc %rax
no_imperfect_block: movq %rax, 80(%rsp)
cmp $7, %rax
jle extra1 /**** jump to the extra section if number of blocks is at most 7 *****/ 



     /**** For larger messages we need to compute number of chunks of blocks of input messages with number of look-ahead blocks(in this that no of look-ahead blocks is 8)********/ 
     comp_lookahead:    /*compute no of perfect chunks of look-ahead blocks*/

               
		
		xorq %rdx, %rdx
		movq $8, %r12
		divq %r12 
		movq %rdx, 80(%rsp)
		movq %rax, 88(%rsp) /*store the number of perfect look-ahead blocks*/
		leaq squares, %rdi
                movq %rdi, 64(%rsp)
       

    
    
     /* prepare stack and other iteration details*/
     movq $1, 96(%rsp)
   
     leaq stack, %r9 
     movq %r9, 160(%rsp)
     movq %r9, 168(%rsp)
     movq $0, 120(%rsp)

/*nrBRW Computation for messsages at least 8-block long*/
        
start:          movq 64(%rsp), %rdx
               
                /* m1+(tau) */
		
		p1: prepare_and_add_store_3 0(%rsi), 8(%rsi), 0(%rdx), 8(%rdx), %r10, %rbp, %r9, %rbx
		
		addq $15, %rsi
		
		/*** m2+tau^2 ***/
	
		p2: prepare_and_add_store_3 0(%rsi), 8(%rsi), 16(%rdx), 24(%rdx), %r11, %r12, %r14, %r15
		addq $15, %rsi
		
		movq 0(%rsi), %r13
		movq 8(%rsi), %rax
		
		addq $15, %rsi
		
		/* m4+tau^4 */
	
		p3: prepare_and_add_store  0(%rsi), 8(%rsi), 32(%rdx), 40(%rdx), 200(%rsp), 208(%rsp), %rdi
		addq $15, %rsi
		
		/*  m5+tau  */

		p4: prepare_and_add 0(%rsi), 8(%rsi), %r10, %rbp, %rcx, %rdi
		addq $15, %rsi
		            
                /* m6+tau^2  */
                
                p5: prepare_and_add_store 0(%rsi), 8(%rsi), %r11, %r12, 216(%rsp), 224(%rsp), %rbp
                addq $15, %rsi
 	
		b1: BRW_7 %r9, %rbx, %r14, %r15, %r13, %rax, 200(%rsp), 208(%rsp), 232(%rsp),240(%rsp),248(%rsp),256(%rsp), 264(%rsp), %rcx, %rdi, 216(%rsp), 224(%rsp), 0(%rsi), 8(%rsi)
		br: addq $15, %rsi
		
		/*******************************************************************************************************************************************************************************/
		
		
		check_stack: movq 96(%rsp), %rbp
    	
                		movq $0, %r13
               
				shrq $1, %rbp
				jc common
				movq 160(%rsp), %r14
			
		loop1:         add_unreduced -40(%r14), -32(%r14), -24(%r14), -16(%r14), -8(%r14)
						
			       inc %r13
                              subq $40, %r14
                              shrq $1, %rbp

        			jnc loop1
        			
        			movq %r14, 160(%rsp)
                
		common:  addq $1, 96(%rsp)
		
		reduce %r8, %r9, %r10, %r11, %r12
	
		
               movq %r9, %rax
                       
		movq 64(%rsp), %rdx
     		addq $48, %rdx
               
		imul $16, %r13, %r13
		addq %r13, %rdx
		
		movq 0(%rsi), %r14
		movq 8(%rsi), %r15
		andq mask56, %r15
		
		addq 0(%rdx), %r14
		adcq 8(%rdx), %r15
		 
		
		
    		mul_2x2  %r12, %rax, %r14, %r15   
    				
    		movq $0, %r12
    		
    		
		
		movq 96(%rsp), %rcx
		
		
		movq 160(%rsp), %rdi
		
		
		addq $15, %rsi
		
		
		
		movq %r8,0(%rdi)
		movq %r9,8(%rdi)
		movq %r10, 16(%rdi)
		movq %r11, 24(%rdi)
		movq %r12, 32(%rdi)
		
		
		cmp %rcx, 88(%rsp)
		
		jl extra
		
		
		addq $40, 160(%rsp)
		
	        
                              
                jmp start
                               


   
   		
   extra: movq 80(%rsp), %rax /*check how many blocks are left...only one case will be satisfied*/
   
   	cmp $0, %rax
   	je common1
   	addq $40, 160(%rsp)
   	
   extra1:     cmp $1, %rax
   	je one
   	cmp $2, %rax
   	je two
   	cmp $3, %rax
   	je three
        cmp $4, %rax
   	je four
        cmp $5, %rax
   	je five
        cmp $6, %rax
   	je six
   	jmp seven
        
   

    one:  	movq 0(%rsi), %r8
    		 
          	movq 8(%rsi), %r9
          	movq $0, %r10
	  	movq $0, %r11
	  	movq $0, %r12
	 
	 	jmp common1
                
          
    two:  	movq 8(%rsi), %rax 
    		andq mask56, %rax
    		movq 0(%rsi), %rcx
    		addq $15, %rsi
    		movq 8(%rsi), %rbx
    		andq mask56, %rbx
    		BRW_2 %rcx, %rax, 0(%rsi), %rbx
         
         	 jmp common1

    three:      movq 64(%rsp), %rdx
               	
		 prepare_and_add 0(%rsi), 8(%rsi), 0(%rdx), 8(%rdx), %r14, %r15
		 addq $15, %rsi     
		       
                prepare_and_add 0(%rsi), 8(%rsi),16(%rdx), 24(%rdx),%rax, %rbx
                addq $15, %rsi
                
                BRW_3	%rax, %rbx, %r14, %r15, 0(%rsi), 8(%rsi)	
                
		jmp common1
		
    four: 	movq 64(%rsp), %rdx
    	  	prepare_and_add 0(%rsi), 8(%rsi), 0(%rdx), 8(%rdx), %rax, %rbx
    	  	addq $15, %rsi
    	  	prepare_and_add 0(%rsi), 8(%rsi), 16(%rdx), 24(%rdx), %r11, %r12
    	  	addq $15, %rsi
    	  	movq 0(%rsi), %rcx
    	  	movq 8(%rsi), %rdi
    	  	andq mask56, %rdi
    	  	addq $15, %rsi
     	  	prepare_and_add_store 0(%rsi), 8(%rsi), 32(%rdx), 40(%rdx), 200(%rsp),208(%rsp), %r14
     	  	
	  	BRW_4 %r11, %r12, %rax, %rbx, %rcx, %rdi, 200(%rsp), 208(%rsp)
    	  
    	  	jmp common1
    	  
    five: 	movq 64(%rsp), %rdx
    	  	prepare_and_add 0(%rsi), 8(%rsi), 0(%rdx), 8(%rdx), %rax, %rbx
    	  	addq $15, %rsi
    	  	prepare_and_add 0(%rsi), 8(%rsi), 16(%rdx), 24(%rdx), %r11, %r12
    	  	addq $15, %rsi
    	  	movq 0(%rsi), %rcx
    	  	movq 8(%rsi), %rdi
    	  	andq mask56, %rdi
    	  	addq $15, %rsi
     	  	prepare_and_add_store 0(%rsi), 8(%rsi), 32(%rdx), 40(%rdx), 200(%rsp),208(%rsp), %r14
     	  	
	  	BRW_4 %r11, %r12, %rax, %rbx, %rcx, %rdi, 200(%rsp), 208(%rsp)
    	        addq $15, %rsi
    	  	add_unreduced 0(%rsi), 8(%rsi), $0, $0, $0
    	  	jmp common1
    	  	  
     six: movq 64(%rsp), %rdx
    	  	prepare_and_add 0(%rsi), 8(%rsi), 0(%rdx), 8(%rdx), %rax, %rbx
    	  	addq $15, %rsi
    	  	prepare_and_add 0(%rsi), 8(%rsi), 16(%rdx), 24(%rdx), %r11, %r12
    	  	addq $15, %rsi
    	  	movq 0(%rsi), %rcx
    	  	movq 8(%rsi), %rdi
    	  	andq mask56, %rdi
    	  	addq $15, %rsi
     	  	prepare_and_add_store 0(%rsi), 8(%rsi), 32(%rdx), 40(%rdx), 200(%rsp),208(%rsp), %r14
     	  	
	  	BRW_4 %r11, %r12, %rax, %rbx, %rcx, %rdi, 200(%rsp), 208(%rsp)
    	        addq $15, %rsi
    	  	movq %r8, 224(%rsp)
    	  	movq %r9, 232(%rsp)
    	  	movq %r10, 240(%rsp)
    	  	movq %r11, 248(%rsp)
    	  	movq %r12, 256(%rsp)
    	  	movq 0(%rsi), %rax
    	  	movq 8(%rsi), %rbx
    	  	andq mask56, %rbx
    	  	addq $15, %rsi
    	  	BRW_2 %rax, %rbx, 0(%rsi), 8(%rsi)
    	  	add_unreduced 224(%rsp), 232(%rsp), 240(%rsp), 248(%rsp), 256(%rsp)
    	  
    	  	jmp common1
    	  
     seven: movq 64(%rsp), %rdx
               
                /* m1+(tau) */
		
		prepare_and_add_store_3 0(%rsi), 8(%rsi), 0(%rdx), 8(%rdx), %r10, %rbp, %r9, %rbx
		
		addq $15, %rsi
		
		/*** m2+tau^2 ***/
	
		prepare_and_add_store_3 0(%rsi), 8(%rsi), 16(%rdx), 24(%rdx), %r11, %r12, %r14, %r15
		addq $15, %rsi
		
		movq 0(%rsi), %r13
		movq 8(%rsi), %rax
		
		addq $15, %rsi
		
		/* m4+tau^4 */
	
		prepare_and_add_store  0(%rsi), 8(%rsi), 32(%rdx), 40(%rdx), 200(%rsp), 208(%rsp), %rdi
		addq $15, %rsi
		
		/*  m5+tau  */

		prepare_and_add 0(%rsi), 8(%rsi), %r10, %rbp, %rcx, %rdi
		addq $15, %rsi
		            
                /* m6+tau^2  */
                
                prepare_and_add_store 0(%rsi), 8(%rsi), %r11, %r12, 216(%rsp), 224(%rsp), %rbp
                addq $15, %rsi
 	
		BRW_7 %r9, %rbx, %r14, %r15, %r13, %rax, 200(%rsp), 208(%rsp), 232(%rsp),240(%rsp),248(%rsp),256(%rsp), 264(%rsp), %rcx, %rdi, 216(%rsp), 224(%rsp), 0(%rsi), 8(%rsi)
		addq $15, %rsi
		
      common1:  movq 160(%rsp), %r14
    		 movq 168(%rsp), %r13

		
                

        loop3:  cmp %r13, %r14
                jle zero_0
               
                add_unreduced -40(%r14), -32(%r14), -24(%r14), -16(%r14), -8(%r14)
		
                subq $40, %r14
    		        
                        
                jmp loop3

      
	zero_0 : 	reduce %r8, %r9, %r10, %r11, %r12
			movq %r9, %rax
			    
    
   wrap_up:     movq    64(%rsp), %rsi


        	movq 16(%rsi), %r14
		movq 24(%rsi), %r15
		

        
        mul_2x2 %r12, %rax, %r14, %r15
	
        movq 112(%rsp), %rdx
        
	
	movq 0(%rsi), %rax
	movq 8(%rsi), %rbx
        
	mulx %rax, %rcx, %r15
	
	mulx %rbx, %rdi, %rsi
	adcx %rdi, %r15
	adcx zero, %rsi

	movq $0, %r12
	
	add_unreduced %rcx, %r15, %rsi, $0, $0
        
       
        
      final_reduction: reduce %r8, %r9, %r10, %r11, %r12
      		
       r:	movq $0, %rax
		shld $1, %r9, %rax
 		and mask63, %r9
 		
 		addq %rax, %r12
 		adcq $0, %r9
	
		movq    %r12, %r11			
		movq    %r9, %rcx	
						
		subq    p0, %r12			
		sbbq    p1,%r9			
						
		movq    %r9,%r10			
		shlq    $1,%r10			
						
		cmovc   %r11,%r12			
		cmovc   %rcx, %r9			

	        andq mask62, %r9
	        
	
		/*final result*/
    		final_result: movq 104(%rsp), %rsi
		
    		movq %r12,0(%rsi) 
    		movq %r9,8(%rsi)
    		/*movq %r10,16(%rsi)
    		movq %r11,24(%rsi)
    		movq %r12, 32(%rsi)*/
    		  
movq 16(%rsp), %rbx
movq 24(%rsp), %r12
movq 32(%rsp), %r13
movq 40(%rsp), %r14
movq 48(%rsp), %r15
movq 56(%rsp), %rbp


addq $300, %rsp

ret





