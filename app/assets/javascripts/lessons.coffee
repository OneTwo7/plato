strBegin = {
  'text-btn': (counter) ->
    '<div id="field-' + counter + '" class="text-field"><div class="field-buttons">
      <button class="btn btn-secondary title-btn" type="button">Title</button>
      <button class="btn btn-secondary link-btn" type="button">Link</button>
      <button class="btn btn-secondary bold-btn" type="button">B</button>
      <button class="btn btn-secondary cursive-btn" type="button">C</button>'
  'code-btn': (counter) ->
    '<div id="field-' + counter + '" class="code-field"><div class="field-buttons">'
  'bash-btn': (counter) ->
    '<div id="field-' + counter + '" class="bash-field"><div class="field-buttons">'
}
strEnd = '<button class="btn btn-secondary erase-btn" type="button">Erase</button></div>
          <pre class="target-field" contenteditable="true" autocorrect="off" autocapitalize="off" spellcheck="false"><div></div></pre>
          <button class="btn btn-danger remove-btn" type="button">Remove</button></div>'
textBtns = ['title', 'link', 'bold', 'cursive']

isChild = ($el, fieldId) ->
  $p = $el.parent()
  while ($p.attr('class') != 'target-field')
    if ($p.is('body') || $p.is 'h2')
      return false
    $p = $p.parent()
  return $p.parent().attr('id') == fieldId

getIndices = (sel) ->
  a = sel.anchorOffset
  f = sel.focusOffset
  if a < f
    return [a, f]
  else
    return [f, a]

handleTextClick = (fieldId, type) ->
  sel = window.getSelection()
  selTxt = sel.toString()
  node = sel.anchorNode
  if (node != null and selTxt != '' and selTxt.length <= node.length)
    $el = $ node
    if (isChild $el, fieldId)
      indices = getIndices sel
      text = $el.text()
      pre = window.sanitizeInput text.slice(0, indices[0])
      aft = window.sanitizeInput text.slice(indices[1])
      if (type == 'title')
        if ($el.parent().is('div'))
          pre = pre + '</div>'
          mid = '<h2>' + selTxt + '</h2>'
          aft = '<div>' + aft if aft.length == 0
        else
          alert 'Can\'t title that!'
          return
      else if (type == 'link')
        href = prompt 'Give me a URL:', ''
        if (href.length > 3)
          href = 'http://' + href if !~href.indexOf('http')
          mid = '<a href=\'' + href + '\'>' + selTxt + '</a>'
        else
          alert 'Invalid URL!'
          return
      else if (type == 'bold')
        mid = '<strong>' + selTxt + '</strong>'
      else
        mid = '<em>' + selTxt + '</em>'
      $el.replaceWith pre + mid + aft
    else
      alert 'Wrong selection!'
  else
    alert 'Select text to transform'
  return

addTextBtnHandler = (type, $field) ->
  $field.find('.' + type + '-btn').click ->
    handleTextClick $field.attr('id'), type
  return

addHandlers = ($field) ->
  $targetField = $field.find '.target-field'
  $targetField.keyup { $field: $targetField }, keepThatInnerDiv
  $targetField.on 'paste', handlePaste
  if ($field.attr('class') == 'text-field')
    addTextBtnHandler item, $field for item in textBtns
  else
    $targetField.keydown handleIndent
  $field.find('.erase-btn').click ->
    $targetField.html '<div></div>'
  $field.find('.remove-btn').click ->
    $field.remove()
  return

keepThatInnerDiv = (event) ->
  if (event.keyCode == 8 or event.keyCode == 13)
    $targetField = event.data.$field
    if ($targetField.html().length == 0)
      $targetField.html '<div></div>'
    else
      $targetField.children('br').each ->
        $(this).replaceWith '<div></div>'
  return

handleIndent = (event) ->
  if (event.keyCode == 9 or event.keyCode == 13)
    sel = window.getSelection()
    offset = sel.anchorOffset
    $div = $(sel.anchorNode)
    $div = $div.parent() unless $div.is('div')
    html = $div.html()
    if (event.keyCode == 9)
      $div.html(html.slice(0, offset) + '\t' + html.slice(offset))
      text = $div.get(0).childNodes[0]
      tabs = offset + 1
    else
      if (sel.toString().length == 0 and html.length >= 1 and html.slice(0, 1) == '\t')
        tabs = 1
        while (html.slice(tabs, tabs + 1) == '\t')
          tabs++
        $newDiv = $('<div></div>')
        $newDiv.insertAfter $div
        $newDiv.html(new Array(tabs + 1).join('\t'))
        text = $newDiv.get(0).childNodes[0]
      else
        return
    range = document.createRange()
    range.setStart(text, tabs)
    range.collapse(true)
    sel.removeAllRanges()
    sel.addRange(range)
    event.preventDefault()
  return

handlePaste = (event) ->
  event.preventDefault()
  sel = window.getSelection()
  node = sel.anchorNode
  $el = $ node
  if (node.nodeType == 3)
    $el = $el.parent()
  elText = $el.text()
  text = (event.originalEvent or event).clipboardData.getData 'text/plain'
  if (elText.length == 0)
    $el.text text
  else
    indices = getIndices sel
    $el.text elText.slice(0, indices[0]) + text + elText.slice(indices[1])
  return

@appendInputField = (btnId, counter) ->
  str = strBegin[btnId](counter) + strEnd
  $field = $ str
  $('#content-field').append($field)
  addHandlers $field
  return

@sanitizeInput = (str) ->
  str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')

@venomizeInput = (str) ->
  str.replace(/&amp;/g,'&').replace(/&lt;/g,'<').replace(/&gt;/g,'>')

@recSanitize = ($obj) ->
  $obj.get(0).childNodes.forEach (item) ->
    if (item.nodeType == 3 and item.nodeValue.trim().length != 0)
      item.nodeValue = window.sanitizeInput(item.nodeValue)
    else
      window.recSanitize($(item))

@recVenomize = ($obj) ->
  $obj.get(0).childNodes.forEach (item) ->
    if (item.nodeType == 3 and item.nodeValue.trim().length != 0)
      item.nodeValue = window.venomizeInput(item.nodeValue)
    else
      window.recVenomize($(item))

@prepareLesson = ($lesson) ->
  window.recVenomize $lesson
  $lesson.find('.code-field').addClass 'prettyprint'
  PR.prettyPrint()
  return