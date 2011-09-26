function confirm_reschedule () {
  if ($("#date-select").val() == "") {
    alert("Please select a date.");
    return false;
  }
  return confirm('Are you sure you want to reschedule this migration?');
};

function count_checked () {
  if ($("input:checked").length == 0) {
    alert("You must specify at least one account before assigning a date.");
    return false;
  }
  if ($("#date-select").val() == "") {
    alert("Please select a date.");
    return false;
  }
  return true;
};

function check_all_checkboxes () {
  $("input[type=checkbox]").each (
    function () {
      this.checked = true;
    });
};

function uncheck_all_checkboxes () {
  $("input[type=checkbox]").each (
    function () {
      this.checked = false;
    });
};

function confirm_cancel () {
  return confirm('Are you sure you want to cancel this migration?');
};

function confirm_block () {
  return confirm('Are you sure you want to block this migration?');
};
