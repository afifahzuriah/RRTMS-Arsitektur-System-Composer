
% Gambar 4.1 Use Case Diagram RRTMS
% Versi perbaikan

clear; clc; close all;

%% ===================== PENGATURAN KANVAS =====================
W = 1500;
H = 1420;

ax = kanvas(W, H);

%% ===================== SYSTEM BOUNDARY =====================
bx = 430;
bw = 640;
by = 70;
bh = 1290;

rectangle(ax, 'Position', [bx by bw bh], ...
    'EdgeColor', 'k', ...
    'FaceColor', 'w', ...
    'LineWidth', 1.5);

T(ax, bx+bw/2, by+26, 'RRTMS', 14, ...
    'FontWeight', 'bold', ...
    'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'middle');

%% ===================== USE CASE =====================
ucx = 750;
ucw = 450;
uch = 130;

ucy = [230 480 730 980 1230];

uc = {
    {'UC-01', 'Memantau perjalanan kereta'}
    {'UC-02', 'Menangani informasi', 'kondisi abnormal'}
    {'UC-03', 'Melihat analisis dampak', 'gangguan'}
    {'UC-04', 'Melihat histori kejadian'}
    {'UC-05', 'Mengelola pengguna', 'dan konfigurasi'}
};

%% ===================== POSISI AKTOR =====================
% Aktor kiri
xl = 190;
opY = 560;
admY = 1150;

% Aktor kanan
xr = 1310;

ry = [150 380 580 780 980 1180];

rnm = {
    {'Onboard', 'Monitoring System'}
    {'Sistem Persinyalan', '(read-only)'}
    {'Monitoring', 'Infrastruktur Jalur'}
    {'Sistem Stasiun'}
    {'Tim Penanganan', 'Gangguan'}
    {'Pusat Kendali', 'Kereta Api'}
};

%% ===================== GARIS ASOSIASI =====================

% Operator Monitoring ke UC-01 sampai UC-04
for k = 1:4
    L(ax, ...
        [xl+18 ucx-ucw/2], ...
        [opY+22 ucy(k)], ...
        '-');
end

% Administrator Sistem ke UC-05
L(ax, ...
    [xl+18 ucx-ucw/2], ...
    [admY+22 ucy(5)], ...
    '-');

% Relasi aktor kanan terhadap use case
% Format: [nomor aktor, nomor use case]
asos = [
    1 1
    1 2
    2 1
    3 2
    4 2
    5 2
    6 4
];

for k = 1:size(asos,1)

    aktorNo = asos(k,1);
    ucNo    = asos(k,2);

    L(ax, ...
        [ucx+ucw/2 xr-18], ...
        [ucy(ucNo) ry(aktorNo)+22], ...
        '-');

end

%% ===================== RELASI EXTEND =====================
% UC-03 memperluas UC-02
% Arah panah menuju UC-02

P(ax, ...
    [ucx ucx], ...
    [ucy(3)-uch/2 ucy(2)+uch/2], ...
    '--');

T(ax, ...
    ucx+15, ...
    (ucy(2)+ucy(3))/2, ...
    '<<extend>>', ...
    11, ...
    'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'middle');

%% ===================== GAMBAR USE CASE =====================
for k = 1:5

    rectangle(ax, ...
        'Position', [ucx-ucw/2 ucy(k)-uch/2 ucw uch], ...
        'Curvature', [1 1], ...
        'EdgeColor', 'k', ...
        'FaceColor', 'w', ...
        'LineWidth', 1.3);

    T(ax, ...
        ucx, ...
        ucy(k), ...
        uc{k}, ...
        11, ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle');

end

%% ===================== GAMBAR AKTOR =====================
% Aktor kiri
aktor(ax, xl, opY, {'Operator', 'Monitoring'});
aktor(ax, xl, admY, {'Administrator', 'Sistem'});

% Aktor kanan
for k = 1:6
    aktor(ax, xr, ry(k), rnm{k});
end

%% ===================== SIMPAN GAMBAR =====================
simpan(ax, 'Gambar_4_1_UseCase.png');

%% =========================================================
%                    FUNGSI BANTU
%% =========================================================

function s = SK()
    s = 0.6;
end

%% ===================== KANVAS =====================
function ax = kanvas(W, H)

    fig = figure( ...
        'Visible', 'on', ...
        'Color', 'w', ...
        'Units', 'pixels', ...
        'Position', [20 20 round(W*SK()) round(H*SK())], ...
        'InvertHardcopy', 'off');

    ax = axes( ...
        'Parent', fig, ...
        'Units', 'normalized', ...
        'Position', [0 0 1 1]);

    hold(ax, 'on');
    axis(ax, 'off');

    set(ax, ...
        'XLim', [0 W], ...
        'YLim', [0 H], ...
        'YDir', 'reverse');

end

%% ===================== SIMPAN GAMBAR =====================
function simpan(ax, f)

    fig = ancestor(ax, 'figure');

    try

        exportgraphics(fig, f, ...
            'Resolution', 300, ...
            'BackgroundColor', 'white');

    catch

        set(fig, 'PaperPositionMode', 'auto');
        print(fig, f, '-dpng', '-r300');

    end

    fprintf('Gambar berhasil disimpan: %s\n', f);

end

%% ===================== TEKS =====================
function T(ax, x, y, s, fs, varargin)

    text(ax, x, y, s, ...
        'FontName', 'Times New Roman', ...
        'FontSize', fs, ...
        'Interpreter', 'none', ...
        'Color', 'k', ...
        varargin{:});

end

%% ===================== GARIS =====================
function L(ax, x, y, g)

    plot(ax, x, y, ...
        'Color', 'k', ...
        'LineStyle', g, ...
        'LineWidth', 1.0);

end

%% ===================== PANAH =====================
function P(ax, x, y, g)

    % Gambar garis relasi
    L(ax, x, y, g);

    % Menghitung arah garis
    dx = x(end) - x(end-1);
    dy = y(end) - y(end-1);

    n = hypot(dx, dy);

    if n == 0
        return;
    end

    % Vektor satuan arah garis
    ux = dx/n;
    uy = dy/n;

    % Ukuran kepala panah
    a = 11;
    w = 4.5;

    % Vektor tegak lurus
    px = -uy;
    py = ux;

    % Koordinat kepala panah
    xHead = [
        x(end)
        x(end)-a*ux+w*px
        x(end)-a*ux-w*px
    ];

    yHead = [
        y(end)
        y(end)-a*uy+w*py
        y(end)-a*uy-w*py
    ];

    % Gambar kepala panah
    fill(ax, xHead, yHead, 'k', ...
        'EdgeColor', 'k');

end

%% ===================== AKTOR UML =====================
function aktor(ax, x, y, baris)

    r = 11;

    % Kepala aktor
    rectangle(ax, ...
        'Position', [x-r y-r 2*r 2*r], ...
        'Curvature', [1 1], ...
        'EdgeColor', 'k', ...
        'FaceColor', 'w', ...
        'LineWidth', 1.3);

    % Badan
    L(ax, [x x], [y+r y+r+34], '-');

    % Tangan
    L(ax, [x-17 x+17], [y+r+11 y+r+11], '-');

    % Kaki
    L(ax, [x x-15], [y+r+34 y+r+62], '-');
    L(ax, [x x+15], [y+r+34 y+r+62], '-');

    % Label aktor
    T(ax, ...
        x, ...
        y+r+72, ...
        baris, ...
        10, ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'top');

end
