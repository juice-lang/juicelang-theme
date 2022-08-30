const zip = (a, b) => a.map((k, i) => [k, b[i]]);

function darkmodeToggled(darkmode) {
    if (darkmode) {
        $('body').removeClass('uk-dark');
        $('body').addClass('uk-light');
    } else {
        $('body').addClass('uk-dark');
        $('body').removeClass('uk-light');
    }
}

$(document).ready(function () {
    if (window.matchMedia) {
        darkmodeToggled(window.matchMedia('(prefers-color-scheme: dark)').matches);

        window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', e => darkmodeToggled(e.matches));
    }
});

function calculateGradient() {
    let navWidth = $('.header-nav').width();
    let logoWidth = $('.logo-image').width();
    let percentage = logoWidth / navWidth + 0.2;

    let start = [223, 142, 21];
    let end = [238, 90, 22];

    let calculateGradient = w => zip(start, end).map(c => Math.round(c[0] * (1 - w) + c[1] * w));

    let gradientEnd = calculateGradient(percentage);
    let hoverGradientStart = calculateGradient(0.4);
    let hoverGradientEnd = calculateGradient(percentage + 0.4);

    $('#logo-gradient').find('stop').eq(1).css('stop-color', `rgb(${gradientEnd[0]}, ${gradientEnd[1]}, ${gradientEnd[2]})`);

    $('#logo-gradient-hover').find('stop').eq(0).css('stop-color', `rgb(${hoverGradientStart[0]}, ${hoverGradientStart[1]}, ${hoverGradientStart[2]})`);
    $('#logo-gradient-hover').find('stop').eq(1).css('stop-color', `rgb(${hoverGradientEnd[0]}, ${hoverGradientEnd[1]}, ${hoverGradientEnd[2]})`);
}

$(document).ready(function () {
    calculateGradient();

    $(window).resize(function () {
        calculateGradient();
    });
});
