
// 自动更新年份
document.getElementById('year').textContent = new Date().getFullYear();


// 标题栏 fetch
fetch('/zeyuchen_econ/header.html')
  .then(response => response.text())
  .then(data => {
    document.getElementById('header').innerHTML = data;
  });


// 导航栏 fetch 并高亮
fetch('/zeyuchen_econ/navigation.html')
  .then(response => response.text())
  .then(navHtml => {
    document.getElementById('navigation').innerHTML = navHtml;

    // 分解路径    
    const pathParts = location.pathname.split('/');
    let navKey = pathParts[1];
    // 需要特殊处理主页（根路径/或没有第三级目录）
    if (!navKey) {
      navKey = 'home';
    }
  
    // 映射目录到导航栏id
    const dirToLiId = {
      'index.html': 'home',
      'notes.html': 'notes',
      'notes': 'notes',
      'research.html': 'research',
      'research': 'research',
    };

    // 高亮当前导航项
    const activeLiId = dirToLiId[navKey];
    if (activeLiId) {
      const activeLi = document.getElementById(activeLiId);
      if (activeLi) activeLi.classList.add('li_active');
    }
  });

  
// 个人信息栏 fetch
fetch('/zeyuchen_econ/personal_info_container.html')
  .then(response => response.text())
  .then(data => {
    document.getElementById('personal_info_container').innerHTML = data;
  });
