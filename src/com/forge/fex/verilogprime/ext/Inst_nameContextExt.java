package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Inst_nameContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Inst_nameContextExt extends AbstractBaseExt {

	public Inst_nameContextExt(Inst_nameContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Inst_nameContext getContext() {
		return (Inst_nameContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).inst_name());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Inst_nameContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Inst_nameContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}