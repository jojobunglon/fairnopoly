#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
class ArticleMailer < ActionMailer::Base
  default from: "kundenservice@fairnopoly.de"

  def report_article(article,text)
    @text = text
    @article = article
    mail(:to => "melden@fairnopoly.de", :subject => "Article reported with ID: " + article.id.to_s)
  end

  def category_proposal(category_proposal)
    mail(:to => "kundenservice@fairnopoly.de", :subject => "Category proposal: " + category_proposal)
  end

end
