package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Clocking_driveContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Clocking_driveContextExt extends AbstractBaseExt {

	public Clocking_driveContextExt(Clocking_driveContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Clocking_driveContext getContext() {
		return (Clocking_driveContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).clocking_drive());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Clocking_driveContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Clocking_driveContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}