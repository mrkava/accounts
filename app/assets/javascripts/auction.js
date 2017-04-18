'use strict';

function change_confirmation_on_show_page() {
    var object = $("a.btn.btn-theme");
    change_confirmation_of_bid_button(object)
}

function change_confirmation_on_index_page() {
    var object = $("#bid_stake").closest('td').next().find('a');
    change_confirmation_of_bid_button(object)
}

function change_confirmation_of_bid_button(obj) {
    $("#bid_stake").blur(function() {
        var bid_stake_value = parseFloat($(this).val());
        var final_price = obj.text();
        var confirm_text = obj.data('confirm')
        final_price = parseFloat(final_price.slice(final_price.indexOf('$')+1));
        if (bid_stake_value >=  final_price) {
            $("[name='commit']").data('confirm', confirm_text)
        }
        else {
            $("[name='commit']").data('confirm', 'Do you confirm the stake? This operation could not be canceled')
        }
    });
}