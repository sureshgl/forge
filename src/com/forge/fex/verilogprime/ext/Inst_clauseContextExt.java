package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Inst_clauseContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Inst_clauseContextExt extends AbstractBaseExt {

	public Inst_clauseContextExt(Inst_clauseContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Inst_clauseContext getContext() {
		return (Inst_clauseContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).inst_clause());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Inst_clauseContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Inst_clauseContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}