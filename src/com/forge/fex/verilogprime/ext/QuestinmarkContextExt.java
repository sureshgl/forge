package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.QuestinmarkContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class QuestinmarkContextExt extends AbstractBaseExt {

	public QuestinmarkContextExt(QuestinmarkContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public QuestinmarkContext getContext() {
		return (QuestinmarkContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).questinmark());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof QuestinmarkContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + QuestinmarkContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}