/*.......1.........2.........3.........4.........5.........6.........7.........8
================================================================================

FILE <model_name>/cfunc.mod


AUTHORS                      

    04 Aug 2024     Christoph Weiser

MODIFICATIONS   


SUMMARY

    This file contains the model-specific routines used to
    functionally describe the simplified sr latch code model.


INTERFACES       

    FILE                 ROUTINE CALLED     

    CMutil.c             void cm_toggle_bit(); 

    CMevt.c              void *cm_event_alloc()
                         void *cm_event_get_ptr()


REFERENCED FILES

    Inputs from and outputs to ARGS structure.
                     

NON-STANDARD FEATURES

    NONE

===============================================================================*/


static void cm_toggle_bit(Digital_State_t *bit) 
{
    if ( UNKNOWN != *bit ) 
    {
        if ( ONE == *bit ) 
        {
            *bit = ZERO;
        }
        else 
        { 
            *bit = ONE;
        }
    }
}


                   
static Digital_State_t cm_eval_sr_result(Digital_State_t s_input,
                                         Digital_State_t r_input,
                                         Digital_State_t old_output)
{
    Digital_State_t     output = ZERO;

    cm_message_printf("------");
    cm_message_printf("s = %i", s_input);
    cm_message_printf("r = %i", r_input);
    cm_message_printf("------");


    switch (s_input) 
    {
        case ZERO:
             switch (r_input) 
             {
                case ZERO: 
                    output = old_output;
                    break;
                case ONE:
                    output = ZERO;
                    break;
                case UNKNOWN:
                    output = old_output;
                    break;
             }
             break; 

        case ONE:
            switch (r_input) 
            {
                case ZERO: 
                    output = ONE;
                    break;
                case ONE:
                    output = ZERO;
                    break;
                case UNKNOWN:
                    output = ONE;
                    break;
            }
            break; 

        case UNKNOWN:
             switch (r_input) 
             {
                case ZERO: 
                    output = old_output;
                    break;
                case ONE:
                    output = ZERO;
                    break;
                case UNKNOWN:
                    output = old_output;
                    break;
             }
        }
    
    return output;
}


void cm_d_sr(ARGS) 

{
    Digital_State_t   *s,       /* current s-input value            */
                      *s_old,   /* previous s-input value           */
                      *r,       /* current r-input value            */
                      *r_old,   /* previous r-input value           */
                      *out,     /* current output for sr            */
                      *out_old, /* previous output for sr           */                            
                      temp;     /* temp storage for state values    */                            


    if(INIT) {  

        /* allocate storage */
        cm_event_alloc(0,sizeof(Digital_State_t));
        cm_event_alloc(1,sizeof(Digital_State_t));
        cm_event_alloc(2,sizeof(Digital_State_t));

        /* declare load values */
        LOAD(s) = PARAM(sr_load);
        LOAD(r) = PARAM(sr_load);

        /* retrieve storage for the outputs */
        s = s_old     = (Digital_State_t *) cm_event_get_ptr(0,0);
        r = r_old     = (Digital_State_t *) cm_event_get_ptr(1,0);
        out = out_old = (Digital_State_t *) cm_event_get_ptr(2,0);

    }
    else {      

        /* retrieve storage for the outputs */
        s       = (Digital_State_t *) cm_event_get_ptr(0,0);
        s_old   = (Digital_State_t *) cm_event_get_ptr(0,1);
        r       = (Digital_State_t *) cm_event_get_ptr(1,0);
        r_old   = (Digital_State_t *) cm_event_get_ptr(1,1);
        out     = (Digital_State_t *) cm_event_get_ptr(2,0);
        out_old = (Digital_State_t *) cm_event_get_ptr(2,1);
    }



    /******* load current input values *******/
    *s = INPUT_STATE(s);
    *r = INPUT_STATE(r);
                            

    /****** DC analysis  ******/
    if (0.0 == TIME) 
    {   

        // Initial condition not required.
        // temp = (Digital_State_t) PARAM(ic);

        /** If there is an unkown input at DC op set the
           output to zero **/
        if ( (*s==UNKNOWN)  || (*r==UNKNOWN)  ) temp = ZERO; 

        /** Modify output s or r lines are active **/
        if ( (*s==ONE)   && (*r==ZERO) ) temp = ONE; 
        if ( (*s==ONE)   && (*r==ONE)  ) temp = ZERO; 
        if ( (*s==ZERO)  && (*r==ZERO) ) temp = ZERO; 
        if ( (*s==ZERO)  && (*r==ONE)  ) temp = ZERO; 


        *out = *out_old = temp;

        OUTPUT_STATE(out)  = temp;
        cm_toggle_bit(&temp);
        OUTPUT_STATE(Nout) = temp;
    }
    /****** Transient Analysis ******/
    else 
    {
        
        if ( ((*s != *s_old) || (*r != *r_old)) ) {
        
                 /* active level...save & output current data value */
                 temp = cm_eval_sr_result(*s,*r,*out_old);
        
                 if (*out_old != temp) {
                     *out = temp;
        
                     OUTPUT_STATE(out) = temp;
                     OUTPUT_DELAY(out) = PARAM(sr_delay);

                     cm_toggle_bit(&temp);
                     OUTPUT_STATE(Nout) = temp;
                     OUTPUT_DELAY(Nout) = PARAM(sr_delay);
                 }
                 else {
                     *out = *out_old;     /* output same as before */
                     OUTPUT_CHANGED(out)  = FALSE;
                     OUTPUT_CHANGED(Nout) = FALSE;
                 }
             }


        /***** Add additional rise or fall delays, if appropriate *****/

        if ( *out != *out_old ) { /*** output value is changing ***/

            switch ( *out ) {
                                                 
            /** fall to zero value **/
            case 0: 
                    OUTPUT_DELAY(out) += PARAM(fall_delay);
                    OUTPUT_DELAY(Nout) += PARAM(rise_delay);
                    break;
    
            /** rise to one value **/
            case 1: 
                    OUTPUT_DELAY(out) += PARAM(rise_delay);
                    OUTPUT_DELAY(Nout) += PARAM(fall_delay);
                    break;
                                    
            /** unknown output **/
            default:
                    /* based on old value, add rise or fall delay */
                    if (0 == *out_old) {  /* add rising delay */
                        OUTPUT_DELAY(out)  += PARAM(rise_delay);
                        OUTPUT_DELAY(Nout) += PARAM(fall_delay);
                    }
                    else {                /* add falling delay */
                        OUTPUT_DELAY(out) += PARAM(fall_delay);
                        OUTPUT_DELAY(Nout) += PARAM(rise_delay);
                    }   
                    break;
            }
        }
    }
              
    OUTPUT_STRENGTH(out)  = STRONG;
    OUTPUT_STRENGTH(Nout) = STRONG;
} 
