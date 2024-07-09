document.addEventListener('DOMContentLoaded', () => {
  const profileButton = document.getElementById('profile-button');
  const accountButton = document.getElementById('account-button');
  const profileEdit = document.getElementById('profile-edit');
  const accountEdit = document.getElementById('account-edit');
  const userInfo = document.getElementById('user-info');

  if (accountEdit) {
    accountEdit.style.display = 'none';
  }

  if (profileButton) {
    profileButton.addEventListener('click', () => {
      if (userInfo) {
        userInfo.style.display = 'none';
      }
      if (profileEdit) {
        profileEdit.style.display = 'block';
      }
      if (accountEdit) {
        accountEdit.style.display = 'none';
      }
    });
  }

  if (accountButton) {
    accountButton.addEventListener('click', () => {
      if (userInfo) {
        userInfo.style.display = 'none';
      }
      if (profileEdit) {
        profileEdit.style.display = 'none';
      }
      if (accountEdit) {
        accountEdit.style.display = 'block';
      }
    });
  }
});
