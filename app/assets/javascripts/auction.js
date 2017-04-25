'use strict';

function change_confirmation_of_bid_button_on_index() {
    $('[data-auction-id]').blur(function() {
        var bid_stake_value = parseFloat($(this).val());
        var obj = $(this).closest('td').next().find('a');
        var final_price = obj.text();
        var confirm_text = obj.data('confirm')
        final_price = parseFloat(final_price.slice(final_price.indexOf('$')+1));
        if (bid_stake_value >=  final_price) {
            $(this).next().data('confirm', confirm_text)
        }
        else {
            $(this).next().data('confirm', 'Do you confirm the stake? This operation could not be canceled')
        }
    });
}

function change_confirmation_of_bid_button_on_show() {
    $("#bid_stake").blur(function() {
        var bid_stake_value = parseFloat($(this).val());
        var obj = $("a.btn.btn-theme");
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