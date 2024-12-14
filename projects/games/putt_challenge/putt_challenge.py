import pygame
import pygame.mixer
import random
import math

pygame.init()
pygame.mixer.init()

# Sound
click_sound = pygame.mixer.Sound('audio/putt_sound.wav')

# Game Window
screen = pygame.display.set_mode((1200, 800))
pygame.display.set_caption("Putt Challenge")
icon = pygame.image.load('static/icon.png')
pygame.display.set_icon(icon)

# Hole
hole_img = pygame.image.load('static/hole.png')
holeX = random.randint(0, 1200)
holeY = random.randint(0, 800)

def hole(x, y):
    screen.blit(hole_img, (x,y))

# Ball
ball_img = pygame.image.load('static/ball.png')
ballX = 568
ballY = 368
ball_speed = 5

def ball(x, y):
    screen.blit(ball_img, (x, y))

def move_ball():
    global ballX, ballY
    targetX = mouse_x - 32
    targetY = mouse_y - 32

    distanceX = targetX - ballX
    distanceY = targetY - ballY
    distance = max(abs(distanceX), abs(distanceY))

    if distance > 0:
        stepX = distanceX / distance
        stepY = distanceY / distance

        for _ in range(int(distance)):
            ballX -= stepX
            ballY -= stepY

            screen.fill((102, 187, 106))
            hole(holeX, holeY)
            ball(int(ballX), int(ballY))
            pygame.display.update()

def display_distance_result(distance):
    font = pygame.font.Font(None, 36)
    text = font.render("Distance to hole: {:.2f}".format(distance), True, (255, 255, 255))
    screen.blit(text, (10, 10))


# Game Loop
running = True
playable = True  # Flag to track game state

while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        elif event.type == pygame.MOUSEBUTTONDOWN:
            if event.button == 1 and playable:
                playable = False  # Disable further interaction
                click_sound.play()
                mouse_x, mouse_y = pygame.mouse.get_pos()
                move_ball()

    # Boundaries
    if ballX <= 0:
        ballX = 0
    elif ballX >= 1136:
        ballX = 1136

    if ballY <= 0:
        ballY = 0
    elif ballY >= 736:
        ballY = 736

    if holeX <= 0:
        holeX = 0
    elif holeX >= 1136:
        holeX = 1136

    if holeY <= 0:
        holeY = 0
    elif holeY >= 736:
        holeY = 736

    screen.fill((102, 187, 106))
    hole(holeX, holeY)
    ball(int(ballX), int(ballY))

    distance_result = math.sqrt((holeX - ballX) ** 2 + (holeY - ballY) ** 2)
    display_distance_result(distance_result)
    
    pygame.display.update()
