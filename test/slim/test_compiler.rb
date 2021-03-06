require 'helper'

class TestEngine
  include Slim::Compiler

  def initialize(template)
    @template = template
    compile
  end

  def compiled
    @compiled
  end
end

class TestSlimEngine < MiniTest::Unit::TestCase

  def test_simple_html
    string = <<HTML
html
  head
    title Simple Test Title
  body
    p Hello World, meet Slim.
HTML

    expected = %q|_buf = [];_buf << "<html>";_buf << "<head>";_buf << "<title>";_buf << "Simple Test Title";_buf << "</title>";_buf << "</head>";_buf << "<body>";_buf << "<p>";_buf << "Hello World, meet Slim.";_buf << "</p>";_buf << "</body>";_buf << "</html>";_buf.join;|

    assert_equal expected, TestEngine.new(string).compiled
  end

  def test_simple_html_with_empty_lines
    string = <<HTML
body

  p Hello World, meet Slim.
HTML

    expected = %q|_buf = [];_buf << "<body>";_buf << "<p>";_buf << "Hello World, meet Slim.";_buf << "</p>";_buf << "</body>";_buf.join;|

    assert_equal expected, TestEngine.new(string).compiled
  end

  def test_simple_html_with_wraparound_text
    string = <<HTML
html
  head
    title Simple Test Title
  body
    p Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean gravida porta neque eu tincidunt. Aenean auctor blandit est sed consectetur. Quisque feugiat massa quis diam vestibulum accumsan. Morbi pharetra accumsan augue, in imperdiet sapien viverra non. Suspendisse molestie metus in sapien hendrerit dictum sit amet et leo. Donec accumsan, justo id porttitor luctus, velit erat tincidunt lorem, eu euismod enim nisl quis justo. Aliquam orci odio, ultricies sed ultrices nec, ultrices at mi. Vestibulum vel lacus eu massa mattis venenatis. In porta, quam ut dignissim varius, neque lectus laoreet felis, eget scelerisque odio lacus sed massa. Donec fringilla laoreet mi in dignissim. Curabitur porttitor ullamcorper ultrices. Quisque hendrerit odio ut ipsum blandit quis molestie diam vehicula. Suspendisse diam nibh, sollicitudin id faucibus et, pharetra sit amet massa. Mauris molestie elit id nulla euismod tempus.
HTML

    expected = %q|_buf = [];_buf << "<html>";_buf << "<head>";_buf << "<title>";_buf << "Simple Test Title";_buf << "</title>";_buf << "</head>";_buf << "<body>";_buf << "<p>";_buf << "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean gravida porta neque eu tincidunt. Aenean auctor blandit est sed consectetur. Quisque feugiat massa quis diam vestibulum accumsan. Morbi pharetra accumsan augue, in imperdiet sapien viverra non. Suspendisse molestie metus in sapien hendrerit dictum sit amet et leo. Donec accumsan, justo id porttitor luctus, velit erat tincidunt lorem, eu euismod enim nisl quis justo. Aliquam orci odio, ultricies sed ultrices nec, ultrices at mi. Vestibulum vel lacus eu massa mattis venenatis. In porta, quam ut dignissim varius, neque lectus laoreet felis, eget scelerisque odio lacus sed massa. Donec fringilla laoreet mi in dignissim. Curabitur porttitor ullamcorper ultrices. Quisque hendrerit odio ut ipsum blandit quis molestie diam vehicula. Suspendisse diam nibh, sollicitudin id faucibus et, pharetra sit amet massa. Mauris molestie elit id nulla euismod tempus.";_buf << "</p>";_buf << "</body>";_buf << "</html>";_buf.join;|

    assert_equal expected, TestEngine.new(string).compiled
  end


  def test_simple_html_with_doctype
    string = <<HTML
! doctype html5
html
  body
    p Hello World, meet Slim.
HTML

    expected = %q|_buf = [];_buf << "<!doctype html5>";_buf << "<html>";_buf << "<body>";_buf << "<p>";_buf << "Hello World, meet Slim.";_buf << "</p>";_buf << "</body>";_buf << "</html>";_buf.join;|

    assert_equal expected, TestEngine.new(string).compiled
  end


  def test_simple_html_with_params
    string = <<HTML
html
  head
    title Simple Test Title
    meta name="description" content="This is a Slim Test, that's all"
HTML

    expected = %q|_buf = [];_buf << "<html>";_buf << "<head>";_buf << "<title>";_buf << "Simple Test Title";_buf << "</title>";_buf << "<meta name=\"description\" content=\"This is a Slim Test, that's all\"/>";_buf << "</head>";_buf << "</html>";_buf.join;|

    assert_equal expected, TestEngine.new(string).compiled
  end

  def test_simple_html_with_params_meta_first
    string = <<HTML
html
  head
    meta name="description" content="This is a Slim Test, that's all"
    title Simple Test Title
HTML

    expected = %q|_buf = [];_buf << "<html>";_buf << "<head>";_buf << "<meta name=\"description\" content=\"This is a Slim Test, that's all\"/>";_buf << "<title>";_buf << "Simple Test Title";_buf << "</title>";_buf << "</head>";_buf << "</html>";_buf.join;|

    assert_equal expected, TestEngine.new(string).compiled
  end

  def test_nested_content
    string = <<HTML
body
  p
    ` Hello World, meet Slim.
  p
    | Hello World, meet Slim again.
HTML

    expected = %q|_buf = [];_buf << "<body>";_buf << "<p>";_buf << "Hello World, meet Slim.";_buf << "</p>";_buf << "<p>";_buf << "Hello World, meet Slim again.";_buf << "</p>";_buf << "</body>";_buf.join;|

    assert_equal expected, TestEngine.new(string).compiled
  end

  def test_closing_tag_without_content_or_attributes
    string = <<HTML
hr
p
  ` Hello World, meet Slim.
HTML

    expected = %q|_buf = [];_buf << "<hr/>";_buf << "<p>";_buf << "Hello World, meet Slim.";_buf << "</p>";_buf.join;|

    assert_equal expected, TestEngine.new(string).compiled
  end


  def test_closing_tag_without_content
    string = <<HTML
img width="100" height="50" src="/images/test.jpg"
p
  ` Hello World, meet Slim.
HTML

    expected = %q|_buf = [];_buf << "<img width=\"100\" height=\"50\" src=\"/images/test.jpg\"/>";_buf << "<p>";_buf << "Hello World, meet Slim.";_buf << "</p>";_buf.join;|

    assert_equal expected, TestEngine.new(string).compiled
  end


  def test_text_that_starts_with_tag_name
    string = <<HTML
p
  ` another one bites the dust
p
  ` i am iron man
HTML

    expected = %q|_buf = [];_buf << "<p>";_buf << "another one bites the dust";_buf << "</p>";_buf << "<p>";_buf << "i am iron man";_buf << "</p>";_buf.join;|

    assert_equal expected, TestEngine.new(string).compiled
  end


  def test_simple_if_code_block
    string = <<HTML
body
  - if something
    p
      ` another one bites the dust
  - else
    p
      ` i am iron man
HTML

    expected = %q|_buf = [];_buf << "<body>";if something;_buf << "<p>";_buf << "another one bites the dust";_buf << "</p>";else;_buf << "<p>";_buf << "i am iron man";_buf << "</p>";end;_buf << "</body>";_buf.join;|

    assert_equal expected, TestEngine.new(string).compiled
  end

  def test_consecutive_if_code_blocks
    string = <<HTML
body
  - if something
    p
      ` another one bites the dust
  - if something_else
    p
      ` i am iron man
HTML

    expected = %q|_buf = [];_buf << "<body>";if something;_buf << "<p>";_buf << "another one bites the dust";_buf << "</p>";end;if something_else;_buf << "<p>";_buf << "i am iron man";_buf << "</p>";end;_buf << "</body>";_buf.join;|

    assert_equal expected, TestEngine.new(string).compiled
  end

  def test_simple_output_code
    string = <<HTML
p
  = hello_world
HTML

    expected = %q|_buf = [];_buf << "<p>";_buf << Slim.escape_html(hello_world);_buf << "</p>";_buf.join;|

    assert_equal expected, TestEngine.new(string).compiled
  end

  def test_simple_output_code_with_params
    string = <<HTML
p
  = hello_world(params[:key])
HTML

    expected = %q|_buf = [];_buf << "<p>";_buf << Slim.escape_html(hello_world(params[:key]));_buf << "</p>";_buf.join;|

    assert_equal expected, TestEngine.new(string).compiled
  end

  def test_simple_html_with_params_and_content_on_same_line
    string = <<TEMPLATE
body
  p id="first" class="hello world" Hello World, meet Slim.
TEMPLATE

    expected = %q|_buf = [];_buf << "<body>";_buf << "<p id=\"first\" class=\"hello world\">";_buf << "Hello World, meet Slim.";_buf << "</p>";_buf << "</body>";_buf.join;|

    assert_equal expected, TestEngine.new(string).compiled
  end

  def test_simple_html_with_params_and_code_call
    string = <<TEMPLATE
body
  p id="first" = hello_world
TEMPLATE

    expected = %q|_buf = [];_buf << "<body>";_buf << "<p id=\"first\">";_buf << Slim.escape_html(hello_world);_buf << "</p>";_buf << "</body>";_buf.join;|

    assert_equal expected, TestEngine.new(string).compiled
  end

  def test_simple_html_with_params_and_parameterized_code_call
    string = <<TEMPLATE
body
  p id="first" = hello_world("Hello Ruby!")
TEMPLATE

    expected = %q|_buf = [];_buf << "<body>";_buf << "<p id=\"first\">";_buf << Slim.escape_html(hello_world("Hello Ruby!"));_buf << "</p>";_buf << "</body>";_buf.join;|

    assert_equal expected, TestEngine.new(string).compiled
  end

  def test_simple_html_with_params_and_spaced_parameterized_code_call
    string = <<TEMPLATE
body
  p id="first" = hello_world "Hello Ruby!"
TEMPLATE

    expected = %q|_buf = [];_buf << "<body>";_buf << "<p id=\"first\">";_buf << Slim.escape_html(hello_world("Hello Ruby!"));_buf << "</p>";_buf << "</body>";_buf.join;|

    assert_equal expected, TestEngine.new(string).compiled
  end

  def test_simple_html_with_params_and_spaced_parameterized_code_call_2
    string = <<TEMPLATE
body
  p id="first" = hello_world "Hello Ruby!", :dummy => "value"
TEMPLATE

    expected = %q|_buf = [];_buf << "<body>";_buf << "<p id=\"first\">";_buf << Slim.escape_html(hello_world("Hello Ruby!", :dummy => "value"));_buf << "</p>";_buf << "</body>";_buf.join;|

    assert_equal expected, TestEngine.new(string).compiled
  end

  def test_simple_html_with_multiple_wraparound_text
    string = <<HTML
p
  `
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam malesuada, dui at condimentum dapibus, purus sapien fringilla est, vel eleifend massa purus ut lectus. Praesent aliquam, ipsum eu ornare porta, tellus lacus viverra diam, nec scelerisque ipsum nunc et lacus. Nam adipiscing velit eget dolor ultricies in dignissim augue ultricies. Sed sed leo in sapien pretium dictum. Fusce sem quam, tincidunt vel lobortis sed, tincidunt vulputate est. Phasellus et ipsum quam, ac fringilla orci. In facilisis est et ante tempus suscipit. Morbi elementum quam ut urna laoreet vel malesuada justo adipiscing. Suspendisse eu lorem id lacus molestie dapibus fringilla ut orci. Cras pellentesque auctor leo, nec bibendum est suscipit id. Mauris dignissim aliquet libero vitae vulputate. Maecenas viverra sodales suscipit. Aenean eu nisi velit.

   Phasellus ultricies vulputate lacus, eget pretium orci tincidunt tristique. Duis vitae luctus risus. Aliquam turpis massa, adipiscing in adipiscing ut, congue sed justo. Sed egestas ullamcorper nisl placerat dictum. Sed a leo lectus, sit amet vehicula nisl. Duis adipiscing congue tortor ut vulputate. Phasellus ligula lectus, congue non lobortis sed, dictum sed tellus. Vestibulum viverra vestibulum felis convallis pharetra. Phasellus a dignissim tellus. Proin dapibus malesuada lorem, et porttitor diam bibendum a. Donec et dui mauris, et tempus metus. Etiam pharetra varius dignissim. Maecenas lacinia, ligula ut tincidunt porttitor, sapien nisi pulvinar magna, nec sollicitudin libero odio bibendum nisi. Aenean ipsum eros, convallis id consequat nec, commodo eget diam. Integer malesuada, libero non dignissim varius, velit metus malesuada lectus, a consequat turpis purus ut elit.
HTML

    expected = %q|_buf = [];_buf << "<p>";_buf << " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam malesuada, dui at condimentum dapibus, purus sapien fringilla est, vel eleifend massa purus ut lectus. Praesent aliquam, ipsum eu ornare porta, tellus lacus viverra diam, nec scelerisque ipsum nunc et lacus. Nam adipiscing velit eget dolor ultricies in dignissim augue ultricies. Sed sed leo in sapien pretium dictum. Fusce sem quam, tincidunt vel lobortis sed, tincidunt vulputate est. Phasellus et ipsum quam, ac fringilla orci. In facilisis est et ante tempus suscipit. Morbi elementum quam ut urna laoreet vel malesuada justo adipiscing. Suspendisse eu lorem id lacus molestie dapibus fringilla ut orci. Cras pellentesque auctor leo, nec bibendum est suscipit id. Mauris dignissim aliquet libero vitae vulputate. Maecenas viverra sodales suscipit. Aenean eu nisi velit.";_buf << "<br/>";_buf << "Phasellus ultricies vulputate lacus, eget pretium orci tincidunt tristique. Duis vitae luctus risus. Aliquam turpis massa, adipiscing in adipiscing ut, congue sed justo. Sed egestas ullamcorper nisl placerat dictum. Sed a leo lectus, sit amet vehicula nisl. Duis adipiscing congue tortor ut vulputate. Phasellus ligula lectus, congue non lobortis sed, dictum sed tellus. Vestibulum viverra vestibulum felis convallis pharetra. Phasellus a dignissim tellus. Proin dapibus malesuada lorem, et porttitor diam bibendum a. Donec et dui mauris, et tempus metus. Etiam pharetra varius dignissim. Maecenas lacinia, ligula ut tincidunt porttitor, sapien nisi pulvinar magna, nec sollicitudin libero odio bibendum nisi. Aenean ipsum eros, convallis id consequat nec, commodo eget diam. Integer malesuada, libero non dignissim varius, velit metus malesuada lectus, a consequat turpis purus ut elit.";_buf << "</p>";_buf.join;|

    iterate_it expected, TestEngine.new(string).compiled
  end

  def test_shortcut_html_with_params
    string = <<TEMPLATE
body
  p#first.hello.world Hello World, meet Slim.
TEMPLATE

    expected = %q|_buf = [];_buf << "<body>";_buf << "<p id=\"first\" class=\"hello world\">";_buf << "Hello World, meet Slim.";_buf << "</p>";_buf << "</body>";_buf.join;|

    assert_equal expected, TestEngine.new(string).compiled
  end

  def test_shortcut_div_tag_with_params
    string = <<TEMPLATE
body
  #first.hello.world Hello World, meet Slim.
TEMPLATE

    expected = %q|_buf = [];_buf << "<body>";_buf << "<div id=\"first\" class=\"hello world\">";_buf << "Hello World, meet Slim.";_buf << "</div>";_buf << "</body>";_buf.join;|

    assert_equal expected, TestEngine.new(string).compiled
  end

  def test_control_code_loop
    string = <<TEMPLATE
p
  - 3.times do
    | Hey!
TEMPLATE

    expected = %q|_buf = [];_buf << "<p>";3.times do;_buf << "Hey!";end;_buf << "</p>";_buf.join;|

    assert_equal expected, TestEngine.new(string).compiled
  end

  def test_call_to_hash
    string = <<TEMPLATE
p = session[:id]
TEMPLATE

    expected = %q|_buf = [];_buf << "<p>";_buf << Slim.escape_html(session[:id]);_buf << "</p>";_buf.join;|

    assert_equal expected, TestEngine.new(string).compiled
  end

  def test_escape_escaping
    string = <<TEMPLATE
p == session[:id]
TEMPLATE

    expected = %q|_buf = [];_buf << "<p>";_buf << session[:id];_buf << "</p>";_buf.join;|

    assert_equal expected, TestEngine.new(string).compiled
  end

  def test_escape_escaping2
    string = <<TEMPLATE
p == safe_method_call
TEMPLATE

    expected = %q|_buf = [];_buf << "<p>";_buf << safe_method_call;_buf << "</p>";_buf.join;|

    assert_equal expected, TestEngine.new(string).compiled
  end

  def test_ruby_comments
    string = <<TEMPLATE
p
  / This is a ruby comment, it won't be displayed in the final render.
  / Neither does this line.
  | But this line should be there.
TEMPLATE

    expected = %q|_buf = [];_buf << "<p>";_buf << "But this line should be there.";_buf << "</p>";_buf.join;|

    assert_equal expected, TestEngine.new(string).compiled
  end

  def test_irregular_indentions
    string = <<TEMPLATE
  body
      p
         | hey
       == hello
TEMPLATE

    expected = %q|_buf = [];_buf << "<body>";_buf << "<p>";_buf << "hey";_buf << hello;_buf << "</p>";_buf << "</body>";_buf.join;|

    assert_equal expected, TestEngine.new(string).compiled
  end

  def test_code_block
    string = <<TEMPLATE
- unless items.empty?
  ul
    - items.each do |item|
      li = item
- else
  p No items
TEMPLATE

    expected = %q|_buf = [];unless items.empty?;_buf << "<ul>";items.each do \|item\|;_buf << "<li>";_buf << Slim.escape_html(item);_buf << "</li>";end;_buf << "</ul>";else;_buf << "<p>";_buf << "No items";_buf << "</p>";end;_buf.join;|

    assert_equal expected, TestEngine.new(string).compiled
  end

  # Use this to do a line by line check. Much easier to see where the problem is.
  def iterate_it(expected, output)
    es = expected.split(';')
    output.split(';').each_with_index do |text, index|
      assert_equal(text, es[index])
    end
  end

end
