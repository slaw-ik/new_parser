// 
//	jQuery Validate example script
//
//	Prepared by David Cochran
//	
//	Free for your use -- No warranties, no guarantees!
//

$(document).ready(function () {

    // Validate
    // http://bassistance.de/jquery-plugins/jquery-plugin-validation/
    // http://docs.jquery.com/Plugins/Validation/
    // http://docs.jquery.com/Plugins/Validation/validate#toptions

    $('#new_user').validate({
        rules:{
            user_email:{
                minlength:2,
                required:true
            },
            user_password:{
                required:true,
                email:true
            },
            user_password_confirmation:{
                minlength:2,
                required:true
            }
        },
        highlight:function (label) {
            $(label).closest('.control-group').addClass('error');
        },
        success:function (label) {
            label
                .text('OK!').addClass('valid')
                .closest('.control-group').addClass('success');
        }
    });

}); // end document.ready