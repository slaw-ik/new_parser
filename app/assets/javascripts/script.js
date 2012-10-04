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
            'user[email]':{
                email:true,
                required:true
            },
            'user[password]':{
                required:true,
                minlength:6,
            },
            'user[password_confirmation]':{
                minlength:6,
                required:true,
                equalTo:"#user_password"
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

    $('#edit_user').validate({
        rules:{
            'user[email]':{
                email:true,
                required:true
            },
            'user[password]':{
                required:true,
                minlength:6
            },
            'user[password_confirmation]':{
                minlength:6,
                required:true,
                equalTo:"#user_password"
            },
            'user[current_password]':{
                minlength:6,
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