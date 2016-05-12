#encoding: utf-8
require 'spec_helper'

describe 'Open baidu homepage' do
  dr = Selenium::WebDriver.for :chrome
  before :all do
    sleep 2
    dr.manage.window.maximize
  end

  after :all do
    dr.quit
    #dr.close()
  end


  it 'load browser correctly' do
    #dr.manage.window.resize_to(320,480)
    dr.get("http://www.baidu.com")
  end
  it 'puts title and url' do
    puts "title of current page is #{dr.title}"
    puts "now access #{dr.current_url}"

    puts 'browser will be closed'
    puts 'browser is closed'
  end
  it 'goforward and back between page' do
    first_url = 'http://www.baidu.com'
    puts "now access #{first_url}"
    dr.get(first_url)
    sleep 1
    second_url = 'http://www.news.baidu.com'
    puts "now access #{second_url}"
    dr.get(second_url)
    sleep 1

    puts "back to #{first_url}"
    dr.navigate.back
    sleep 1
    puts "forward to #{first_url}"
    dr.navigate.forward
    sleep 1
  end

  it 'simple locate element' do
    file_path = 'file:///' + File.expand_path(File.join('./html', 'form_locate.html'))
    #file_path =  'file:///' + File.expand_path("../../html/form.html", __FILE__)

    dr.get(file_path)

    # by id
    dr.find_element(:id, 'inputEmail').click
    sleep 2

    # by name
    dr.find_element(:name, 'password').click
    sleep 2

    # by tagname
    puts dr.find_element(:tag_name, 'form')[:class]
    sleep 2

    # by class_name
    e = dr.find_element(:class, 'controls')
    dr.execute_script('$(arguments[0]).fadeOut().fadeIn()', e)
    sleep 2

    # by link text
    link = dr.find_element(:link_text, 'register')
    dr.execute_script('$(arguments[0]).fadeOut().fadeIn()', link)
    sleep 2

    # by partial link text
    link = dr.find_element(:partial_link_text, 'reg')
    dr.execute_script('$(arguments[0]).fadeOut().fadeIn()', link)
    sleep 2

    # by css selector
    div = dr.find_element(:css, '.controls')
    dr.execute_script('$(arguments[0]).fadeOut().fadeIn()', div)
    sleep 2

    # by xpath
    dr.find_element(:xpath, '/html/body/form/div[3]/div/label/input').click
    sleep 2
  end

  it 'locate a group of element' do
    file_path = 'file:///' + File.expand_path(File.join('./html', 'checkbox.html'))
    dr.get(file_path)

    dr.find_elements(:css, 'input[type=checkbox]').each do |checkbox|
      checkbox.click
    end
    sleep 1

    dr.navigate.refresh()
    sleep 1

    puts dr.find_elements(:css, 'input[type=checkbox]').size

    dr.find_elements(:tag_name, 'input').each do |input|
      input.click if input.attribute(:type) == 'checkbox'
    end
    sleep 1

    dr.find_elements(:css, 'input[type=checkbox]').last.click
    sleep 1

  end

  it 'locate element by level' do
    file_path = 'file:///' + File.expand_path(File.join('./html', 'level_locate.html'))
    dr.get(file_path)

    dr.find_element(:link_text, 'Link1').click
    wait = Selenium::WebDriver::Wait.new({:timeout => 10})
    wait.until {dr.find_element(:id, 'dropdown1').displayed?}
    menu = dr.find_element(:id, 'dropdown1').find_element(:link_text, 'Another action')
    sleep 2

    dr.action.move_to(menu).perform()

    sleep 2
  end

  it 'operate element' do
    file_path = 'file:///' + File.expand_path(File.join('./html', 'operate_element.html'))
    dr.get(file_path)

    #click
    dr.find_element(:link_text, 'Link1').click
    sleep 1
    dr.find_element(:link_text, 'Link1').click

    #send_keys
    element = dr.find_element(:name, 'q')
    element.send_keys('something')
    sleep 1

    #clear
    element.clear()

    sleep 2
  end

  it 'operate button group' do
    file_path = 'file:///' + File.expand_path(File.join('./html', 'button_group.html'))
    dr.get(file_path)

    second_button = dr.find_element(:class, 'btn-group').find_elements(:class, 'btn').detect do |btn|
      btn.text == 'second'
    end
    #second_button = dr.find_element(:xpath, '/html/body/div/div/div/div/div/div[2]')
    second_button.click
    sleep 1
    alertBox = dr.switch_to.alert
    puts alertBox.text
    alertBox.accept
    sleep 1
  end

  it 'operate button dropdown' do
    file_path = 'file:///' + File.expand_path(File.join('./html', 'button_group.html'))
    dr.get(file_path)

    # 定位text是watir-webdriver的下拉菜单
    # 首先显示下拉菜单
    dr.find_element(:link_text, 'Info').click()
    wait = Selenium::WebDriver::Wait.new(timeout: 10)
    wait.until { dr.find_element(:class, 'dropdown-menu').displayed? }

    # 通过ul再层级定位
    dr.find_element(:class, 'dropdown-menu').find_element(:link_text, 'watir-webdriver').click()
    sleep(1)
  end

  it 'operate navs' do
    file_path = 'file:///' + File.expand_path(File.join('./html', 'navs.html'))
    dr.get(file_path)

    dr.find_element(:class, 'nav').find_element(:link_text, 'About').click
    sleep 1

    dr.find_element(:link_text, 'Home').click
    sleep 1
  end

  it 'operate bread crumb' do
    file_path = 'file:///' + File.expand_path(File.join('./html', 'breadcrumb.html'))
    dr.get(file_path)

    anstors = dr.find_element(:class, 'breadcrumb').find_elements(:tag_name, 'a').map do |link|
      link.text
    end
    puts anstors

    # dr.find_element(:class, 'breadcrumb').find_elements(:tag_name, 'a').each do |link|
    #   puts link.text
    # end

    sleep 1

    puts dr.find_element(:class, 'breadcrumb').find_element(:class, 'active').text
  end

  it 'operate modal dialog' do
    file_path = 'file:///' + File.expand_path(File.join('./html', 'modal.html'))
    dr.get(file_path)

    dr.find_element(:id, 'show_modal').click

    wait = Selenium::WebDriver::Wait.new(timeout:10)
    wait.until { dr.find_element(:id, 'myModal').displayed? }

    link = dr.find_element(:id, 'myModal').find_element(:id, 'click')
    dr.execute_script('$(arguments[0]).click()', link)
    sleep 5

    #dr.find_element(:class, 'modal-footer').find_elements(:tag_name, 'button')[1].click
    dr.find_element(:class, 'modal-footer').find_elements(:tag_name, 'button').first.click
  end

  it 'get attribute of element' do
    file_path = 'file:///' + File.expand_path(File.join('./html', 'attribute.html'))
    dr.get(file_path)

    link = dr.find_element(:id, 'tooltip')
    puts link.attribute('data-original-title')
    puts link.text()
  end

  it 'get css attribut' do
    file_path = 'file:///' + File.expand_path(File.join('./html', 'css.html'))
    dr.get(file_path)

    link = dr.find_element(id: 'tooltip')
    puts link.css_value(:color)

    puts dr.find_element(:tag_name, 'h3').css_value('font')
  end

  it 'get status of element' do
    file_path = 'file:///' + File.expand_path(File.join('./html', 'status.html'))
    dr.get(file_path)

    text_field = dr.find_element(:name, 'user')
    puts text_field.enabled?

    puts dr.find_element(:class, 'btn').enabled?

    # dr.execute_script('$(arguments[0]).hide()', text_field)
    # puts text_field.enabled?

    radio = dr.find_element(:name, 'radio')
    radio.click
    puts radio.selected?

    begin
      dr.find_element(:id, 'none')
    rescue Selenium::WebDriver::Error::NoSuchElementError
      puts 'element does not exist'
    end
  end

  it 'operate form' do
    file_path = 'file:///' + File.expand_path(File.join('./html', 'form.html'))
    dr.get(file_path)

    dr.find_element(:css, 'input[type=checkbox]').click()
    sleep 1

    dr.find_element(:class, 'radio').click()
    sleep 1

    dr.find_element(:tag_name, 'select').find_elements(:tag_name, 'option').last.click()
    sleep 1

    dr.find_element(:class, 'btn').click
    sleep 1

    alert = dr.switch_to.alert
    puts alert.text
    alert.accept()
  end

  it 'operate alert,confirm and prompt dialog' do
    file_path = 'file:///' + File.expand_path(File.join('./html', 'alert.html'))
    dr.get(file_path)

    dr.find_element(:id, 'tooltip').click()
    sleep 1

    alert = dr.switch_to.alert
    alert.accept()
    #alert.dismiss()
    puts alert.text
    sleep 1
  end

  it 'wait element' do
    file_path = 'file:///' + File.expand_path(File.join('./html', 'wait.html'))
    dr.get(file_path)

    dr.find_element(:id, 'btn').click()
    wait = Selenium::WebDriver::Wait.new()
    wait.until {dr.find_element(class: 'label').displayed?}
    sleep 2
  end

  it 'operate element in frame' do
    file_path = 'file:///' + File.expand_path(File.join('./html', 'frame.html'))
    dr.get(file_path)

    dr.switch_to.frame('f1')
    dr.switch_to.frame('f2')

    dr.find_element(:id, 'kw').send_keys('watir-webdriver')

    dr.switch_to.default_content
    sleep 2

    dr.switch_to.frame('f1')
    dr.find_element(:link_text, 'click').click()
    sleep 2
  end

  it 'upload file' do
    file_path = 'file:///' + File.expand_path(File.join('./html', 'upload_file.html'))
    dr.get(file_path)

    dr.find_element(:name, 'file').send_keys('/Users/ctuo/RubymineProjects/selenium_webdriver/test.txt')
    sleep 5
  end

  it 'download file' do
    profile = Selenium::WebDriver::Chrome::Profile.new
    # 设置自动下载
    profile['download.prompt_for_download'] = false
    # 设置具体路径
    profile['download.default_directory'] = '/Users/ctuo/RubymineProjects/selenium_webdriver/download'

    driver = Selenium::WebDriver.for :chrome, :profile => profile
  end

  it 'set cookie' do
    url = 'http://www.baidu.com'
    dr.get url

    puts dr.manage.all_cookies
    dr.manage.delete_all_cookies
    dr.manage.add_cookie(name: 'BAIDUID', value: '90A739C33F2263418B2B3AE5D3FB1B8F:FG=1')
    dr.manage.add_cookie(name: 'BDUSS', value: 'VSbjA3MmRWWlB0S2NjbU4zZVEzRmtEZEpnSFZzbnJMVXRDTXRZYU4zOUlyRFZYQVFBQUFBJCQAAAAAAAAAAAEAAAAL4LYKdHVvX2NoYW8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEgfDldIHw5XcV')
    sleep 2

    dr.navigate.refresh()
    sleep(3)
  end
end