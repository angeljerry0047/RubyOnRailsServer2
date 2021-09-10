require 'prawn'
require 'prawn/table'

class OrganizationReportPdf < Prawn::Document
  attr_reader :organization_report, :document

  # Values used for the manual design:

  # This is the default value for the margin box
  #
  BOX_MARGIN   = 40

  # Additional indentation to keep the line measure with a reasonable size
  #
  INNER_MARGIN = 10

  ICON_WIDTH = 32

  # Vertical Rhythm settings
  #
  RHYTHM  = 10
  LEADING = 2

  # Colors
  RGB_TO_HEX = ->(arr) { arr.map { |n| n.to_s(16) }.join }

  BLACK = '000000'.freeze
  LIGHT_GRAY = RGB_TO_HEX.call([223, 223, 223])
  MEDIUM_GRAY = RGB_TO_HEX.call([128, 130, 133])
  DARK_GRAY = RGB_TO_HEX.call([54, 54, 54])
  BLUE = RGB_TO_HEX.call([59, 119, 181])
  ORANGE = RGB_TO_HEX.call([217, 130, 62])
  GREEN = RGB_TO_HEX.call([103, 192, 116])
  LIGHT_BLUE = RGB_TO_HEX.call([74, 115, 214])

  def initialize(organization_report)
    @organization_report = organization_report

    # Beware of the super vs super() ;)
    super()

    font_families.update('Myriad' => {
                           bold: Rails.root.join('app/assets/fonts/myriad-pro/MyriadWebPro-Bold.ttf').to_s,
                           italic: Rails.root.join('app/assets/fonts/myriad-pro/MyriadWebPro-Italic.ttf').to_s,
                           normal: Rails.root.join('app/assets/fonts/myriad-pro/MyriadWebPro.ttf').to_s,
                           bold_italic: Rails.root.join('app/assets/fonts/myriad-pro/myriadprobolditalic.ttf').to_s
                         })

    font 'Myriad', size: 10

    ## preamble!   +++++++++++++++++++++++++++++++++++

    header("#{@organization_report.organization_title} Activity Report")
    top = cursor
    width = bounds.right / 2.0

    bounding_box([0, top], width: width, height: 180) do
      font('Myriad', size: 14) do
        text "<i><b>#{@organization_report.organization_title}</b></i> Activity Report",
             { inline_format: true, style: :bold }
      end

      move_down RHYTHM * 2
      fill_color BLACK

      font('Myriad', size: 12) do
        text "dated #{@organization_report.created_at.strftime('%D')} \n", { style: :bold, inline_format: true }
      end
      stroke_color 'FFFFFF'

      font('Myriad', size: 8)
      table([['Total Users :', @organization_report.users_nbr.to_s],
             ['Total Skill Hours Delivered :', @organization_report.pdes_created_nbr.to_s],
             ['Total Skill Hours Received :',
              @organization_report.pdes_attended_nbr.to_s]], position: :left, cell_style: { padding_right: 1, borders: [] })

      stroke_color BLACK
    end

    bounding_box([width, top], width: width, height: 200) do
      # Render icons
      # Lines
      # Labels
      # Bars

      vertical_margins = 10
      increment = (bounds.right - bounds.left - ICON_WIDTH) / 4.0

      5.times do |i|
        stroke_color MEDIUM_GRAY

        tt = (i * 10)

        shift = tt == 0 ? 3 : 0
        draw_text tt.to_s, at: [(increment * i) + ICON_WIDTH + shift, 0]

        stroke_vertical_line bounds.bottom + 8, bounds.top, at: (increment * i) + ICON_WIDTH + 5
      end

      render_bar_for_group('users', 1, @organization_report.users_nbr, LIGHT_BLUE)
      render_bar_for_group('pdes_created', 2, @organization_report.pdes_created_nbr, ORANGE)
      render_bar_for_group('pdes_attended', 3, @organization_report.pdes_attended_nbr, GREEN)
    end
  end

  def header(str)
    header_box do
      image Rails.root.join('app/assets/images/s2p_logo.png').to_s, position: :left, vposition: 20, scale: 0.60
      font('Myriad', size: 20, style: :bold) do
        fill_color BLUE

        bounding_box([0, cursor], width: bounds.right - BOX_MARGIN) do
          text(str, valign: 20, align: :right, inline_format: true)
        end
      end
    end
  end

  def header_box(&block)
    bounding_box([-bounds.absolute_left, cursor + BOX_MARGIN],
                 width: bounds.absolute_left + bounds.absolute_right,
                 height: BOX_MARGIN * 2 + RHYTHM * 1) do
                   fill_color LIGHT_GRAY
                   fill_rectangle([bounds.left, bounds.top],
                                  bounds.right,
                                  bounds.top - bounds.bottom)
                   fill_color BLACK

                   indent(BOX_MARGIN + INNER_MARGIN, &block)
                 end
    move_down(RHYTHM * 2)
  end

  def render_bar_for_group(_group, i, number, color)
    score = (number.to_f / 40) * 240
    rectangle_height = 30
    spacing = 30
    fill_color color
    stroke_color color

    fill { rectangle [bounds.left + ICON_WIDTH + 5, i * (rectangle_height + spacing)], score, rectangle_height }
  end

  def color_for(group)
    colors = {
      users: LIGHT_BLUE,
      pdes_created: ORANGE,
      pdes_attended: GREEN
    }

    colors.fetch(group.name.to_sym) { LIGHT_BLUE }
  end

  def icon_for(group)
    icons = {
      users: 'app/assets/images/icon_leadership.png',
      pdes_created: 'app/assets/images/icon_influence.png',
      pdes_attended: 'app/assets/images/icon_performance.png'
    }

    icons.fetch(group.name.to_sym) { 'app/assets/images/icon_leadership.png' }
  end
end
