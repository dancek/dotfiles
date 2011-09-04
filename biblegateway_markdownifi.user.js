// ==UserScript==
// @name           BibleGateway markdownifier
// @namespace      http://github.com/dancek
// @description    Create copypasteable markdown from BibleGateway passages
// @include        http://www.biblegateway.com/passage/*
// @require        https://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js  
// @version        0.1dev
// @author         Hannu Hartikainen
// @license        MIT
// ==/UserScript==

// String formatting function
// http://stackoverflow.com/questions/610406/javascript-equivalent-to-printf-string-format/4673436#4673436
String.prototype.format = function() {
  var args = arguments;
  return this.replace(/{(\d+)}/g, function(match, number) { 
    return typeof args[number] != 'undefined'
      ? args[number]
      : '{' + number + '}'
    ;
  });
};

// answer template
var markdownTemplate = "> [**{0} {1}**]({2}) {3}";

// Parse and format (hacky...)
$(document).ready(function() {
    var $textarea = $('<textarea rows="25" cols="80" class="markdown-export"></textarea>');

    var passage = $("div.heading.passage-class-0 > h3").text();
    var translation = $("div.heading.passage-class-0 > p.txt-sm").text();
    var translation_abbr = /\([^)]*\)/.exec(translation);

    var $text = $("div.result-text-style-normal").clone();

    // remove unnecessary stuff
    $.each(['div', 'sup.xref', 'sup.footnote'], function(i, matcher) {
        $text.find(matcher).remove();
    });
    $text.find('sup').removeAttr('class').removeAttr('id');

    var text = $text.html();
    text = text.replace(/<br *\/?>/gi, '<br />\n> ');
    text = text.replace(/<p><\/p>/gi, '');
    text = text.replace(/<p>/gi, '<br />\n> ');
    text = text.replace(/<\/p>/gi, '');

    // generate the complete markdown
    var markdown = markdownTemplate.format(
            passage,
            translation_abbr,
            document.location,
            text
        );

    // populate textarea and set focus handler
    $textarea.text(markdown);
    $textarea.focus(function() {this.select()});
    
    $("div.passage-left").append($textarea);
});
