create database exhx2411p; --cria a database
use exhx2411p; -- usa a database 

create table PARTIDA ( --cria a tabela partida
	idpartida int not null auto_increment,
    nomejogo varchar (255),
    fornecedorjogo varchar(255),
    horainicio datetime,
    horafim datetime,
	numerojogadores int,
    primary key(idpartida)
);

create table JOGADOR ( -- cria a tabel jogador
	idjogador int not null auto_increment,
    nomejogador varchar(255),
    niveljogador int,
    primary key(idjogador)
);

create table HISTORICOPARTIDA( -- cria a tabela historico partida
                                --essa tabela eh a equivalente JogandoPartida
	idhistoricopartida int not null auto_increment,
    idjogador int,
    idpartida int,
    horaentrada datetime,
    horasaida datetime,
    primary key(idhistoricopartida),
    constraint FK_idjogador foreign key (idjogador) references JOGADOR(idjogador),
    constraint FK_idpartida foreign key (idpartida) references PARTIDA(idpartida)
);

 DELIMITER $ --criacao de gatilho
 CREATE TRIGGER adicionar_jogador_partida
 after insert on HISTORICOPARTIDA
 for each row
 BEGIN
 update PARTIDA set numerojogadores = numerojogadores + 1
 where PARTIDA.idpartida = new.idpartida;
 END $
 DELIMITER ;


DELIMITER $ -- criacao de gatilho
CREATE TRIGGER remover_jogador_partida
AFTER UPDATE ON HISTORICOPARTIDA
FOR EACH ROW
BEGIN
  IF NEW.horasaida IS NOT NULL THEN
    UPDATE PARTIDA
    SET numerojogadore = numerojogadores - 1
    WHERE idpartida = NEW.idpartida;
  END IF;
END $
DELIMITER ;

DELIMITER $ --criacao da procedure
CREATE PROCEDURE inserir_jogador_partida(
	IN idjogador INT,
	IN idpartida INT)
BEGIN
	INSERT INTO HISTORICOPARTIDA (idjogador, idpartida, horaentrada)
	VALUES (idjogador, idpartida, NOW());
END $
DELIMITER ;

DELIMITER $ --criacao de procedure  
CREATE PROCEDURE remover_jogador_partida(
	IN id_historicopartida INT)
BEGIN
	UPDATE  HISTORICOPARTIDA set horasaida = NOW()
    where id_historicopartida = HISTORICOPARTIDA.idhistoricopartida;
END $
DELIMITER ;

create view vw_jogador_jogo as --CRIACAO DA VISAO
SELECT JOGADOR.nomejogador as nome_jogador,
HISTORICOPARTIDA.idpartida as partida 
from JOGADOR
inner join HISTORICOPARTIDA 
on HISTORICOPARTIDA.idjogador = JOGADOR.idjogador ;


